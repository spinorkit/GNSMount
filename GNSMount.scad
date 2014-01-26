include <metric.scad>

boxMountHoleSpacing = 103.5;
boxInsideWidth = 113;
boxWidthGap = 0.5;

boardMountingHoleFromBox = 14;  //The distance from the closest board mounting hole to the inside of th e box

boardMountingHoleSpacing = 68.7;
boxHoleLongSpacing = 134.3;
boardHoleLongSpacing = 125.16;
boardHoleOffsetFromBoxHoles = (boxHoleLongSpacing-boardHoleLongSpacing)/2;

reinforceThickness = 3.5;
width = 10+reinforceThickness;
height = 9;
thickness = 2.5;
nutRetainerOuterAcross = 10/cos(30);
radius = 1.5;

numHoleSegs = 32;

unreinforcedWidth = width-reinforceThickness;

boxHolesCenterY = unreinforcedWidth/2+reinforceThickness;
boardHolesCenterY = boxHolesCenterY - boardHoleOffsetFromBoxHoles;
centerBoardHoleCenterY = boxHolesCenterY - boardHoleOffsetFromBoxHoles;

module GNSMount(inputEnd = 0)
{
length = boxInsideWidth-2*boxWidthGap;
boardMountCenterX = -length/2 + boardMountingHoleFromBox - boxWidthGap + boardMountingHoleSpacing/2;
difference()
	{
	union()
	   {
		translate([-length/2+radius,radius,0])
			minkowski()
				{	
				cube([length-2*radius,width-2*radius,thickness]);
				cylinder(h = thickness/10000, r = radius, $fn = numHoleSegs);
				}
		translate([-length/2+radius,0,0])
			hull()
				{
				translate([height,0,0])
	   	   	cube([length-2*height,reinforceThickness,height]);
	   	   cube([length-2*radius,reinforceThickness,height/10]);
				}
	   if(inputEnd == 1)
			{
	//Center Board mount nut retainer
			translate([boardMountCenterX, centerBoardHoleCenterY, 0])
				NutRetainerPos();
			}
	   else
			{//Output end
			translate([boardMountCenterX - boardMountingHoleSpacing/2,boardHolesCenterY,0])
				NutRetainerPos();
			translate([boardMountCenterX + boardMountingHoleSpacing/2,boardHolesCenterY,0])
				NutRetainerPos();
			}
      }

	   if(inputEnd == 1)
			{
			translate([boardMountCenterX, centerBoardHoleCenterY, 0])
				NutRetainerNeg();
         }
      else
         {
			translate([boardMountCenterX - boardMountingHoleSpacing/2,boardHolesCenterY,0])
				NutRetainerNeg();
			translate([boardMountCenterX + boardMountingHoleSpacing/2,boardHolesCenterY,0])
				NutRetainerNeg();
         }
	   if(inputEnd == 1)
			{
		//Center Board mount hole
			translate([boardMountCenterX, centerBoardHoleCenterY, -thickness/2])
			   cylinder(h = thickness*2, r = m3_diameter/2, $fn = numHoleSegs);
         }
      else
         {
		//Outer Board mount holes
			translate([boardMountCenterX - boardMountingHoleSpacing/2, boardHolesCenterY, -thickness/2])
			   cylinder(h = thickness*2, r = m3_diameter/2, $fn = numHoleSegs);
			translate([boardMountCenterX + boardMountingHoleSpacing/2, boardHolesCenterY, -thickness/2])
			   cylinder(h = thickness*2, r = m3_diameter/2, $fn = numHoleSegs);
         }
//Box mount holes
	translate([-boxMountHoleSpacing/2, boxHolesCenterY, -thickness/2])
	   cylinder(h = thickness*2, r = m3_diameter/2, $fn = numHoleSegs);
	translate([+boxMountHoleSpacing/2, boxHolesCenterY, -thickness/2])
	   cylinder(h = thickness*2, r = m3_diameter/2, $fn = numHoleSegs);
	}
}

module NutRetainerPos(retainerH = 4)
{
//difference()
	{
	//translate([0, 0, thickness]) 
	      cylinder(h =retainerH+thickness, r = nutRetainerOuterAcross/2, $fn = 6);

//		}
	}
}

module NutRetainerNeg(retainerH = 4)
{
	   translate([0, 0, thickness])
			cylinder(h =height, r = m3_nut_diameter_horizontal/2, $fn = 6);

}


GNSMount(inputEnd = 1);

translate([0,-(13),0])
   mirror([0,1,0])
      GNSMount(inputEnd = 0);

