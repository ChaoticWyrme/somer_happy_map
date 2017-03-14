import org.gicentre.geomap.*;
import org.gicentre.geomap.io.*;

GeoMap geoMap;
Table data;
color minColor;
color maxColor;

//arrays
int[] mapID = {-1,2,3,1,5,4,6,7}; // Takes ward ID from data turns it into map ID
String[] dataColumns = {"How.happy.do.you.feel.right.now.","How.satisfied.are.you.with.your.life.in.general.","How.satisfied.are.you.with.Somerville.as.a.place.to.live.","How.satisfied.are.you.with.your.neighborhood.","How.proud.are.you.to.be.a.Somerville.resident._2015","How.would.you.rate.the.following..The.availability.of.information.about.city.services._2015","The.availability.of.affordable.housing_2011","How.would.you.rate.the.following..The.cost.of.housing.","How.would.you.rate.the.following..The.beauty.or.physical.setting.of.Somerville_2013","How.would.you.rate.the.following..The.effectiveness.of.the.local.police_2011_2013","How.would.you.rate.the.following..Your.trust.in.the.local.police_2015","How.would.you.rate.the.following..The.maintenance.of.streets..sidewalks..and..squares_2013","How.would.you.rate.the.following..The.maintenance.of.streets.and.sidewalks_2015","How.would.you.rate.the.following..The.availability.of.social.community.events","How.safe.do.you.feel.walking.in.your.neighborhood.at.night_2013","How.safe.do.you.feel.walking.in.your.community.at.night._2015","How.satisfied.are.you.with.the.beauty.or.physical.setting.of.your.neighborhood.","How.satisfied.are.you.with.the.appearance.of.parks.in.your.neighborhood._2013","How.satisfied.are.you.with.the.appearance.of.parks.and.squares.in.your.neighborhood."};

void setup() {
  size(1080,720);
  geoMap = new GeoMap(this);
  geoMap.readFile("Wards");
  data = loadTable("SomerHappy.csv", "header");
  fill(255);
  stroke(0);
  background(255);
  println(dataColumns.length);
  geoMap.draw(); //<>//
  drawAvg(0);
  noLoop();
}

void drawAvg(int catNum) {
  int dataColID = data.getColumnIndex(dataColumns[catNum]); //Switch this number from 0-18 to switch data.
  float[] wardAvg = new float[7];
  for (int i = 1; i <= 7; i++) {
    float total = 0.0;
    int n = 0; //<>//
    for(TableRow row : data.findRows(Integer.toString(i), "Ward")) {
      if(!Float.isNaN(row.getFloat(dataColID))) {
        total += row.getFloat(dataColID);
        n++;
      }
    }
    wardAvg[i-1] = total/n;
    println("Ward "+i+": "+wardAvg[i-1]);
    String col = "yellow";
    if(col == "green") {
      minColor = color(0,100,0);
      maxColor = color(50,205,50);
    } else if(col == "yellow") {
      minColor = color(139,69,19);
      maxColor = color(255,255,0);
    }
    fill(lerpColor(minColor, maxColor, norm(wardAvg[i-1],1,10)));
    geoMap.draw(mapID[i]);
  }
}