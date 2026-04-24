from flask import Flask, render_template, request
import xml.etree.ElementTree as ET
import xml.dom.minidom as DOM

app = Flask(__name__)

XML_FILE = "transport.xml"


def get_stations():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    stations = {}
    for s in root.findall("stations/station"):
        stations[s.get("id")] = s.get("name")
    return stations


@app.route('/')
def index():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    stations = get_stations()

    trips = []

    for line in root.findall("lines/line"):
        for trip in line.findall("trips/trip"):
            trips.append({
                "code": trip.get("code"),
                "type": trip.get("type"),
                "departure": stations[line.get("departure")],
                "arrival": stations[line.get("arrival")],
                "dep_time": trip.find("schedule").get("departure"),
                "arr_time": trip.find("schedule").get("arrival"),
                "prices": [(c.get("type"), c.get("price")) for c in trip.findall("class")],
                "days": trip.find("days").text
            })

    return render_template("index.html", trips=trips)


@app.route('/search')
def search():
    code = request.args.get("code")

    doc = DOM.parse(XML_FILE)
    trips = doc.getElementsByTagName("trip")

    result = None

    for t in trips:
        if t.getAttribute("code") == code:

            schedule = t.getElementsByTagName("schedule")[0]

            classes = []
            for c in t.getElementsByTagName("class"):
                classes.append({
                    "type": c.getAttribute("type"),
                    "price": c.getAttribute("price")
                })

            days = t.getElementsByTagName("days")[0].firstChild.nodeValue

            result = {
                "code": code,
                "type": t.getAttribute("type"),
                "departure_time": schedule.getAttribute("departure"),
                "arrival_time": schedule.getAttribute("arrival"),
                "classes": classes,
                "days": days
            }

    return render_template("search.html", trip=result)


@app.route('/filter')
def filter_trips():
    dep = request.args.get("departure")
    arr = request.args.get("arrival")
    typ = request.args.get("type")
    max_price = request.args.get("price")

    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    stations = get_stations()

    trips = []

    for line in root.findall("lines/line"):

        dep_name = stations[line.get("departure")]
        arr_name = stations[line.get("arrival")]

        if dep and dep_name != dep:
            continue
        if arr and arr_name != arr:
            continue

        for trip in line.findall("trips/trip"):

            if typ and trip.get("type") != typ:
                continue

            prices = [int(c.get("price")) for c in trip.findall("class")]

            if max_price:
                if min(prices) > int(max_price):
                    continue

            trips.append({
                "code": trip.get("code"),
                "type": trip.get("type"),
                "departure": dep_name,
                "arrival": arr_name,
                "dep_time": trip.find("schedule").get("departure"),
                "arr_time": trip.find("schedule").get("arrival"),
                "prices": [(c.get("type"), c.get("price")) for c in trip.findall("class")],
                "days": trip.find("days").text
            })

    return render_template("index.html", trips=trips)



@app.route('/line_stats')
def line_stats():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()

    results = []

    for line in root.findall("lines/line"):
        trips = line.findall("trips/trip")

        min_trip = None
        max_trip = None
        min_price = float('inf')
        max_price = 0

        for trip in trips:
            prices = [int(c.get("price")) for c in trip.findall("class")]
            price = min(prices)  

            if price < min_price:
                min_price = price
                min_trip = trip.get("code")

            if price > max_price:
                max_price = price
                max_trip = trip.get("code")

        results.append({
            "line": line.get("code"),
            "cheapest": min_trip,
            "cheap_price": min_price,
            "expensive": max_trip,
            "exp_price": max_price
        })

    return render_template("line_stats.html", results=results)


@app.route('/stats')
def stats():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()

    # حساب عدد الرحلات لكل نوع قطار
    types = {}
    for trip in root.findall(".//trip"):
        t = trip.get("type")
        types[t] = types.get(t, 0) + 1

    # بناء قاموس الإحصائيات
    stats = {
        "Total Trips": len(root.findall(".//trip")),
        "Trips per Train Type": types
    }

    return render_template("stats.html", stats=stats)



if __name__ == '__main__':
    app.run(debug=True)
