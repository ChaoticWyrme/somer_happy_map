import org.gicentre.geomap.*;
import org.gicentre.geomap.io.*;

GeoMap geoMap;
Table data;
color minColor;
color maxColor;
String message = "Enter a number from 0-17";
int dataSet = 0;
int dataDisp = 0;
int digit = 10;
boolean dataEntered = false; // Has data been entered once?
boolean dataEntry = true; // Is data being entered now?

//arrays
int[] mapID = {-1,2,3,1,5,4,6,7}; // Takes ward ID from data turns it into map ID
String[] dataColumns = {"How.happy.do.you.feel.right.now.","How.satisfied.are.you.with.your.life.in.general.","How.satisfied.are.you.with.Somerville.as.a.place.to.live.","How.satisfied.are.you.with.your.neighborhood.","How.proud.are.you.to.be.a.Somerville.resident._2015","The.availability.of.information.about.city.services._2015","The.cost.of.housing.","The.beauty.or.physical.setting.of.Somerville_2013","The.effectiveness.of.the.local.police_2011_2013","Your.trust.in.the.local.police_2015","The.maintenance.of.streets.sidewalks.and.squares_2013","The.maintenance.of.streets.and.sidewalks_2015","The.availability.of.social.community.events","How.safe.do.you.feel.walking.in.your.neighborhood.at.night_2013","How.safe.do.you.feel.walking.in.your.community.at.night._2015","How.satisfied.are.you.with.the.beauty.or.physical.setting.of.your.neighborhood.","How.satisfied.are.you.with.the.appearance.of.parks.in.your.neighborhood._2013","How.satisfied.are.you.with.the.appearance.of.parks.and.squares.in.your.neighborhood."};

void setup() {
  size(720,480);
  //geoMap = new GeoMap(this); // default bounds
  geoMap = new GeoMap(10,10,width-20,height-20,this); //custom bounds
  geoMap.readFile("Wards");
  data = loadTable("SomerHappy.csv", "header");
  fill(255);
  stroke(0);
  background(255);
  println(dataColumns.length);
  geoMap.draw();
}

void draw() {
  background(255);
  fill(0);
  text(message,width/3,height/8,width/4*3,height/8*2);
  if(!dataEntry) text("Opinion on :",width/3,height/16,width/4*3,height/8);
  if(dataEntered) {
    drawAvg(dataDisp);
  } else {
    fill(255);
    geoMap.draw();
  }
}

void keyPressed() {
  if((key==RETURN || key==ENTER) && digit == 0) {
    dataEntered = true;
    dataEntry = false;
    drawAvg(dataSet);
    message = normCatNames(dataColumns[dataSet]);
    dataDisp = dataSet;
    dataSet = 0;
    digit = 10;
  } else if((key==BACKSPACE || key==DELETE) && dataSet > 0) {
    switch(digit) {
      case 1:
        dataSet = 0;
        digit = 10;
        break;
      case 0:
        dataSet -= dataSet%10;
        digit = 1;
        break;
    }
  } else if(Character.isDigit(key) && digit > 0) {
    int keyVal = Character.getNumericValue(key);
    dataEntry = true;
    if(digit == 10 && keyVal < 2) {
        dataSet += keyVal * digit;
        message = Integer.toString(dataSet);
        digit = 1;
    }else if(digit == 1 && keyVal < 8) {
        dataSet += keyVal * digit;
        message = Integer.toString(dataSet);
        digit = 0;
    }
  }
}

// Functions

public void drawAvg(int catNum, boolean debug) {
  int dataColID = data.getColumnIndex(dataColumns[catNum]); //Switch this number from 0-17 to switch data.
  float[] wardAvg = new float[7];
  if(debug) {
    println("Debug enabled");} // has breakpoint //<>//
  for (int i = 1; i <= 7; i++) {
    float total = 0.0;
    int n = 0;
    for(TableRow row : data.findRows(Integer.toString(i), "Ward")) {
      if(!Float.isNaN(row.getFloat(dataColID))) {
        total += row.getFloat(dataColID);
        n++;
      }
    }
    wardAvg[i-1] = total/n;
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
  //text(normCatNames(dataColumns[catNum]),400,10,720,20); deprecated
  if(debug) {
    int n = 1;
    for(float avg : wardAvg) {
      println("Ward "+n+" average: "+wardAvg[n]);
    }
  }
}

public void drawAvg(int catNum) {
  drawAvg(catNum,false);
}

public static String normCatNames(String catName) {
  catName = catName.replaceAll("\\.(?!$)"," ");
  catName = catName.replaceAll("_([0-9]{4})", "($1)");
  catName = catName.replaceAll("\\.", "?");
  catName = catName.replaceAll("(?<=[a-zA-Z])(?=\\s?\\([01235]{4}\\)$)","?");
  catName = catName.replaceAll("\\?\\(","? (");
  catName = catName.replaceAll("[ ]{2,}", " ");
  return catName;
}