#!/usr/bin/env ruby

require "csv"
require "json"

health_input = ARGV.fetch(0)
geography_input = ARGV.fetch(1)
health_output = ARGV.fetch(2)
geography_output = ARGV.fetch(3)

geojson = JSON.parse(File.read(geography_input))
features = geojson.fetch("features")
raise "Expected 58 California county features, found #{features.length}" unless features.length == 58

features.each do |feature|
  properties = feature.fetch("properties")
  raise "Non-California feature found" unless properties.fetch("STATE") == "06"
  raise "Invalid county GEOID" unless properties.fetch("GEOID").match?(/\A06\d{3}\z/)
end

features.sort_by! { |feature| feature.fetch("properties").fetch("GEOID") }
raise "Duplicate GEOIDs" unless features.map { |f| f["properties"]["GEOID"] }.uniq.length == 58

fips_by_name = features.to_h do |feature|
  properties = feature.fetch("properties")
  [properties.fetch("NAME").sub(/ County\z/, ""), properties.fetch("GEOID")]
end

selected = []
CSV.foreach(health_input, headers: true, encoding: "bom|utf-8") do |row|
  id_text = row["Health Care Delivery System Id"]
  county_id = id_text.to_i
  next unless id_text == county_id.to_s && (1..58).include?(county_id)
  next unless row["DEMO_GRP"] == "S1 Female"
  next unless row["POP_CAT"] == "Adult"
  next unless row["DEMO_CAT"] == "Sex"

  county_name = row.fetch("Health Care Delivery System")
  county_fips = fips_by_name[county_name]
  raise "No Census match for DHCS county #{county_name.inspect}" unless county_fips

  eligible = row["TOTAL_CT"].to_s.strip
  served = row["MHS1_CT"].to_s.strip
  rate = if !eligible.empty? && !served.empty? && eligible.to_f.positive?
           format("%.2f", 100.0 * served.to_f / eligible.to_f)
         end
  status = rate ? "reported" : "suppressed_or_unavailable"

  selected << {
    "county_name" => "#{county_name} County",
    "county_fips" => county_fips,
    "fiscal_year" => row.fetch("FISCAL_YEAR"),
    "delivery_system" => row.fetch("MEDI_CAL_DELIVERY_SYSTEM"),
    "eligible_adult_female_medi_cal_beneficiaries" => eligible,
    "adult_female_beneficiaries_with_1plus_mental_health_service" => served,
    "mental_health_service_penetration_percent" => rate,
    "value_status" => status,
    "source_mhs1_annotation" => row["MHS1_CT_ANNOT"].to_s.strip
  }
end

expected_rows = 58 * 4 * 2
raise "Expected #{expected_rows} selected health rows, found #{selected.length}" unless selected.length == expected_rows

selected.sort_by! do |row|
  [row.fetch("county_fips"), row.fetch("fiscal_year"), row.fetch("delivery_system")]
end

headers = selected.first.keys
CSV.open(health_output, "w", write_headers: true, headers: headers) do |csv|
  selected.each { |row| csv << row }
end

clean_features = features.map do |feature|
  properties = feature.fetch("properties")
  {
    "type" => "Feature",
    "properties" => {
      "GEOID" => properties.fetch("GEOID"),
      "NAME" => properties.fetch("NAME"),
      "STATEFP" => properties.fetch("STATE"),
      "COUNTYFP" => properties.fetch("COUNTY")
    },
    "geometry" => feature.fetch("geometry")
  }
end

File.write(
  geography_output,
  JSON.generate({"type" => "FeatureCollection", "features" => clean_features})
)

puts "health_rows=#{selected.length}"
puts "health_counties=#{selected.map { |row| row["county_fips"] }.uniq.length}"
puts "geographic_counties=#{clean_features.length}"
puts "reported_rows=#{selected.count { |row| row["value_status"] == "reported" }}"
puts "suppressed_or_unavailable_rows=#{selected.count { |row| row["value_status"] != "reported" }}"
