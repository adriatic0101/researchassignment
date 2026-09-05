"""Small Playwright smoke test for the static dashboard.

Run while serving the project root on http://127.0.0.1:8765.
"""

from pathlib import Path
from playwright.sync_api import sync_playwright


URL = "http://127.0.0.1:8765/index.html"


def main():
    console_errors = []
    page_errors = []
    failed_requests = []

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1440, "height": 1000})
        page.on("console", lambda message: console_errors.append(message.text) if message.type == "error" else None)
        page.on("pageerror", lambda error: page_errors.append(str(error)))
        page.on("requestfailed", lambda request: failed_requests.append(f"{request.url}: {request.failure}"))
        response = page.goto(URL, wait_until="domcontentloaded", timeout=60_000)
        assert response and response.ok, f"Page request failed: {response.status if response else 'no response'}"

        page.wait_for_function("state.rows.length === 464", timeout=60_000)
        page.wait_for_function("state.mapReady === true", timeout=60_000)
        page.wait_for_timeout(2_000)

        assert page.locator("#status").is_hidden(), page.locator("#status").inner_text()
        assert page.locator("#map canvas.maplibregl-canvas").count() == 1
        assert page.evaluate("state.geojson.features.length") == 58
        assert page.evaluate("state.map.getSource('counties')._data.features.length") == 58
        assert page.evaluate("Boolean(state.map.getLayer('county-fill'))")
        assert page.locator("#trend-chart svg").count() == 1
        assert page.locator("#year-select").input_value() == "2022/23"
        assert page.locator("#system-select").input_value() == "NSMHS"

        states_checked = 0
        for year in ("2019/20", "2020/21", "2021/22", "2022/23"):
            for system in ("NSMHS", "SMHS"):
                page.select_option("#year-select", year)
                page.select_option("#system-select", system)
                expected_reported = page.evaluate(
                    "([year, system]) => state.rows.filter(d => d.fiscal_year === year && d.delivery_system === system && d.value !== null).length",
                    [year, system],
                )
                mapped_reported = page.evaluate(
                    "state.geojson.features.filter(f => Object.prototype.hasOwnProperty.call(f.properties, 'access_value')).length"
                )
                assert page.locator("#rank-chart rect.bar").count() == expected_reported
                assert page.locator("#scatter-chart circle.county").count() == expected_reported
                assert mapped_reported == expected_reported
                assert f"{year} {system}" in page.locator("#rank-subtitle").inner_text()
                assert "Suppressed / unavailable" in page.locator("#legend").inner_text()
                states_checked += 1

        page.screenshot(path="/tmp/california-mental-health-dashboard.png", full_page=True)
        browser.close()

    if page_errors or console_errors or failed_requests:
        raise AssertionError(
            f"page_errors={page_errors}; console_errors={console_errors}; failed_requests={failed_requests}"
        )

    screenshot = Path("/tmp/california-mental-health-dashboard.png")
    print("Browser check passed")
    print("Health rows loaded: 464")
    print("County map loaded: yes")
    print(f"Year/system states checked: {states_checked}")
    print("D3 charts loaded: 3")
    print("Console errors: 0")
    print("Failed network requests: 0")
    print(f"Screenshot: {screenshot} ({screenshot.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
