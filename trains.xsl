<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">

<html>
<head>
    <title>Train Trips Report</title>
    <style>
       body {
    font-family: Arial, sans-serif;
    background: url('img.png') no-repeat center center fixed;
    background-size: cover;
    margin: 0;
    padding: 15px;
    position: relative;
}


body::before {
    content: "";
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.6); 
    z-index: -1;
}


      h1 {
    position: fixed;      
    top: 0;               
    left: 0;
    width: 100%;           
    text-align: center;
    background: #1e3a8a;
    color: white;
    padding: 12px;
    margin: 0;
    z-index: 1000; 
     }


        .line-banner {
    background: rgba(30,58,138,0.65); 
    color: #ffffff;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
    padding: 12px;
    border-radius: 12px;
    margin: 60px 0 25px 0;
    backdrop-filter: blur(6px);   
    box-shadow: 0 4px 12px rgba(0,0,0,0.25); 
    letter-spacing: 0.5px;
    font-family: 'Segoe UI', 'Poppins', sans-serif;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}


.line-banner:hover {
    transform: scale(1.03);
    box-shadow: 0 6px 16px rgba(0,0,0,0.35);
}


       .trip-title {
    font-size: 18px;
    font-weight: 700;
    color: #ffffff;              
    letter-spacing: 0.5px;
    margin-bottom: 8px;
    text-transform: uppercase;
    font-family: 'Segoe UI', 'Poppins', sans-serif;
    text-shadow: 0 0 6px rgba(0, 150, 255, 0.7); 
}


.days {
    font-size: 18px;              
    color: #f9f7f7;               
    font-weight: 600;
    background: transparent;     
    padding: 10px 16px;
    border-radius: 10px;
    display: inline-block;
    font-family: 'Segoe UI', 'Poppins', sans-serif;
    box-shadow: 0 0 12px rgba(0, 150, 255, 0.6); 
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    margin-bottom: 20px;          
}


.days:hover {
    transform: scale(1.05);
    box-shadow: 0 0 18px rgba(0, 150, 255, 0.9);
}



 table {
    width: 90%;
    border-collapse: collapse;
    margin: 25px auto;
    background: #ffffff;
    box-shadow: 0 4px 14px rgba(0,0,0,0.12);
    border-radius: 12px;
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease; 
}


table:hover {
    transform: scale(1.03); 
    box-shadow: 0 6px 18px rgba(0,0,0,0.2);
}

th {
    background: linear-gradient(to right, #1e3a8a, #3b82f6);
    color: #ffffff;
    font-weight: bold;
    padding: 12px;
    text-align: center;
    font-size: 15px;
    letter-spacing: 0.5px;
}

td {
    border-bottom: 1px solid #eee;
    padding: 12px;
    text-align: center;
    font-size: 15px;
    font-weight: 600;
    color: #111;
}

tr:nth-child(even) {
    background-color: #f9fafb;
}

tr:hover {
    background-color: #e0f2fe;
    transition: 0.3s;
}

td.price {
    color: #008000;
    font-weight: bold;
}



    </style>
</head>

<body>

<h1>🚆 Train Trips Report</h1>

<div class="container">

<xsl:for-each select="transport/lines/line">

   
    <div class="line-banner">
        <xsl:variable name="depId" select="@departure"/>
        <xsl:variable name="arrId" select="@arrival"/>
        Line: <xsl:value-of select="@code"/> 
        (<xsl:value-of select="/transport/stations/station[@id=$depId]/@name"/> 
         → 
         <xsl:value-of select="/transport/stations/station[@id=$arrId]/@name"/>)
    </div>

    <xsl:for-each select="trips/trip">

        <div class="trip-title">
            Trip <xsl:value-of select="@code"/> | Type: <xsl:value-of select="@type"/>
        </div>

        <div class="days">
            Days: <xsl:value-of select="days"/>
        </div>

        <table>
            <tr>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Train Type</th>
                <th>Class</th>
                <th>Price (DA)</th>
            </tr>

            <xsl:for-each select="class">
                <tr>
                    <td><xsl:value-of select="../schedule/@departure"/></td>
                    <td><xsl:value-of select="../schedule/@arrival"/></td>
                    <td><xsl:value-of select="../@type"/></td>
                    <td><xsl:value-of select="@type"/></td>
                    <td class="price"><xsl:value-of select="@price"/></td>
                </tr>
            </xsl:for-each>
        </table>

    </xsl:for-each>

</xsl:for-each>

</div>

</body>
</html>

</xsl:template>

</xsl:stylesheet>



