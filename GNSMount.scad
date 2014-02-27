include <metric.scad>

boxMountHoleSpacing = 104;
boxInsideWidth = 114.5;
boxWidthGap = 0.5;
boxHoleDiameter = 4;

boardMountingHoleFromBox = 15;  //The distance from the closest board mounting hole to the inside of th e box

boardMountingHoleSpacing = 68.7;
boxHoleLongSpacing = 133.6;
boardHoleLongSpacing = 125.16;
boardHoleOffsetFromBoxHoles = (boxHoleLongSpacing-boardHoleLongSpacing)/2;

reinforceThickness = 2.8;
width = 10+reinforceThickness;
height = 9;
thickness = 2.0;//1.75; //not including thickener
nutRetainerOuterAcross = 10/cos(30);
radius = 3;
supportGap = 2;

//Extra support for the center bolt provided by touching bottom of box
centralSupportLen = 20;
centralSupportExtraHeight = 3;

//Horizontal thickener
thickenerEndGap = 10.5;
thickenerHeight = 0.75;//1;

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
		//Main horizontal plate
		translate([-length/2+radius,radius,0])
			minkowski()
				{	
				cube([length-2*radius,width-2*radius,thickness]);
				cylinder(h = thickness/10000, r = radius, $fn = numHoleSegs);
				}
		//Horizontal thickener
		translate([-length/2+thickenerEndGap,0,thickness])
			hull()
				{
				translate([4*thickenerHeight,0,0])
	   	   	cube([length-2*thickenerEndGap-8*thickenerHeight,width,thickenerHeight]);
	   	   cube([length-2*thickenerEndGap,width,thickenerHeight/100]);
				}
		
		//Vertical support plate
		translate([-length/2+supportGap,0,0])
			hull()
				{
				translate([height,0,0])
	   	   	cube([length-2*supportGap-2*height,reinforceThickness,height]);
	   	   cube([length-2*supportGap,reinforceThickness,height/100]);
				}
	   if(inputEnd == 1)
			{
	//Center Board mount nut retainer
			translate([boardMountCenterX, centerBoardHoleCenterY, 0])
				NutRetainerPos();			
			
			translate([boardMountCenterX-centralSupportLen/2,0,height])
				hull()
					{
					translate([centralSupportExtraHeight,0,0])
		   	   	cube([centralSupportLen-2*centralSupportExtraHeight,reinforceThickness,centralSupportExtraHeight]);
		   	   cube([centralSupportLen,reinforceThickness,centralSupportExtraHeight/10]);
					}

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
	   cylinder(h = thickness*2, r = boxHoleDiameter/2, $fn = numHoleSegs);
	translate([+boxMountHoleSpacing/2, boxHolesCenterY, -thickness/2])
	   cylinder(h = thickness*2, r = boxHoleDiameter/2, $fn = numHoleSegs);
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
			cylinder(h = height+centralSupportExtraHeight, r = m3_nut_diameter_horizontal/2, $fn = 6);

}


//Standoff parameters
boardH = 1.9;

module Standoff(hasNutRetainer = 1, retainerH = 6.5, separatorH = 19.1, sepDiameter = 8,clipTopLen = 4.6,clipW = 8,holeDia = 3.2,holeToEdge = 3.0,joinW = 4)
{
holeCenterToEdge = holeDia/2+holeToEdge;
nutToBoard = 2.5;
supportFlat = 1;
retainerConeH = 1;
nutRadiusExtra = 0.15;
holeRadius = m3_diameter/2+0.2;
clipLen = clipTopLen + joinW;
translate([0,0,boardH+retainerH])
difference()
	{
	union()
		{
		//hull()
			{
			cylinder(h = separatorH, r = sepDiameter/2, $fn = 6);
			//translate([-supportFlat/2,-joinW-holeCenterToEdge,0])
			//	cube([supportFlat,clipLen,separatorH]);
			}
		
		translate([-clipW/2,-joinW-holeCenterToEdge,-retainerH-boardH])
			cube([clipW,clipLen,retainerH+boardH+thickness]);
		
			translate([0,0,-retainerH-boardH])
				//rotate([0,0,30])
					if(hasNutRetainer == 1)
				   	cylinder(h =retainerH, r = (nutRetainerOuterAcross-0.6)/2, $fn = 6);
					else
				   	cylinder(h =retainerH, r = (sepDiameter)/2, $fn = 24);

//	   translate([11, 0, -retainerConeH-boardH-nutToBoard])
//			//rotate([0,0,30])
//				cylinder(h = retainerConeH, r2 = m3_diameter/2+0.1,r1 = m3_nut_diameter_horizontal/2, $fn = 6);

		}
	union()
		{
		translate([-clipW,-holeCenterToEdge,-boardH])
			cube([clipW*2,clipLen,boardH]);
		translate([0,0,-2*retainerH])
//			rotate([0,0,30])
//				cylinder(h = separatorH*2, r = 1.2*m3_diameter/2, $fn = 6);
				cylinder(h = separatorH*2, r = holeRadius, $fn = 16);
		if(hasNutRetainer == 1)
			{
		   translate([0, 0, -retainerConeH-nutToBoard-boardH-0.1])
				//rotate([0,0,30])
					cylinder(h = retainerConeH, r2 = holeRadius,r1 = m3_nut_diameter_horizontal/2+nutRadiusExtra, $fn = 6);
		   translate([0, 0, -retainerH-nutToBoard-boardH-retainerConeH])
				//rotate([0,0,30])
					cylinder(h = retainerH, r = m3_nut_diameter_horizontal/2+nutRadiusExtra, $fn = 6);
			}
		}
	}

}

//rotate([90,0,0])
//	Standoff();

spacing = 20;
halfSpacing = spacing/2;

translate([-7,0,0])
	{
	translate([halfSpacing,halfSpacing,0])
		Standoff();
	translate([-halfSpacing,halfSpacing,0])
		Standoff();

	translate([halfSpacing,-halfSpacing,0])
		Standoff(hasNutRetainer = 0, retainerH = 2.5);
	translate([-halfSpacing,-halfSpacing,0])
		Standoff(hasNutRetainer = 0, retainerH = 2.5);
	}


//GNSMount(inputEnd = 1);
//
//translate([0,30,0])
//   mirror([0,1,0])
//      GNSMount(inputEnd = 0);

