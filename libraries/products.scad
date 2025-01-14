// Products

include <ub.scad>; // requires ub.scad https://github.com/UBaer21/UB.scad
pVersion=23.110;

/*change log
23|022 UPD HingBox  
23|026 ADD WaveWasher  
23|045 ADD BallSocket
23|055 UPD BallSocket
23|080 ADD Plug UPD WaveWasher
23|110 ADD MicroSD ADD NEMA


//*/

/** \name NEMA
NEMA() is a NEMA stepper dummy
\param nr the designation 11,14,17,23
\param l  length of the motor
\param rot rotate arbor
\param help help
*/

module NEMA(nr=17,l=34.3,rot=0,help){
data=[
["nr[0]","size[1]","holes[2]","arbor[3]","arborL[4]","disc[5]","discH[6]","flat[7]","holeD[8]"],

[11     ,    28.3 ,        23,         5,         24,       22,         2,       15, 2.5],
[14     ,    35   ,        26,         5,         24,       22,         2,       15, 3],
[17     ,    42.3 ,        31,         5,         24,       22,         2,       15, 3],
[23     ,    56.4 ,     47.14 ,      6.35,         21,     38.1,      1.6,       15, 5]

];
set=data[search([nr],data)[0]];
HelpTxt("NEMA",["nr",nr,"l",l],help);
//echo(set);
  Tz(l-.1)cylinder(set[6]+.1,d=set[5],$fn=0);
  Tz(l+.1)rotate(rot)difference(){
    cylinder(set[4]-.1,d=set[3],$fn=0);
    Tz(set[4]-set[7])T(set[3]/2 -.5 , -25)cube(50);
    }
  difference(){
    linear_extrude(l)
    Quad(set[1],rad=set[1]/8,fn=nr<20?4:36);
    //  offset(delta=set[1]/4,chamfer=nr<23?true:false)square(set[1]/2,true);
    //holes  
    Tz(l-4.5)for(x=[-1,1],y=[-1,1])translate([x,y]*set[2]/2)cylinder(h=50,d=set[8],$fn=0);
  }
}



/** \name MicroSD
MicroSD() makes a micro SD card
\param ofs offset increases size
\param h thickness (+ofs)
\param center center x
\param notch  enalble notch
\pram help

*/

//MicroSD();

module MicroSD(ofs=0.15,h=.8,center=false,notch=true,help){
/*
full-size SD card	32 x 24 x 2.1 mm	2g
miniSD card	21.5 x 20 x 1.4 mm	0.8g
microSD card	15 x 11 x 1 mm
*/
HelpTxt("MicroSD",["ofs",ofs,"h",h,"center",center,"notch",notch],help);
p=[
[0,0],
[9.7,0],
[9.7,5.1],
[11,6.2],
if(notch)[11,8],// notch
if(notch)[10.3,8.5],//< notch
if(notch)[10.3,9.5],//< notch
if(notch)[11,10],// notch
[11,15],
[0,15],
];

  T(center?[-11/2,0,-h/2-ofs]:0){
    linear_extrude(h+ofs*2,center=false)offset(ofs)polygon(p);
    
    T(-ofs,15-1.8+ofs,.001)intersection(){
      mirror([0,0,1])linear_extrude(.3)offset(ofs)offset(-ofs)square([11+ofs*2,1.8]);
      T(11/2,25-ofs)cylinder(5,d=50,center=true);
    }
  }

}

/** \name Plug
Plug() creates a Plug for a tube
\param dia  diameter
\param h    height
\param wall wall thickness
\param lip  tube wall thickness
\param rad  radius of the top
\param clips number of clips
\param infoPos imprint of the diameter position
\param info  true for imprint diameter
*/


module Plug(dia=20,h=18,wall=1,lip=0.75,rad=0,clips=5,infoPos=[0,0],info=false,help){
od=dia+wall*2;
rad=rad?rad:od/3;

HelpTxt("Plug",["dia",dia,"h",h,"wall",wall,"lip",lip,"rad",rad,"clips",clips,"infoPos",infoPos,"info",info],help);

InfoTxt("Plug",["clips",clips],true);
h2=2;

  difference(){
   Anschluss([h,h2],d1=dia,d2=od,rad=1,grad=45,center=false);
   VarioFill([1,2],dia=-dia,exp=1);
   Tz(h/2)Polar(clips,-dia/2)R(90)linear_extrude(5,center=true,convexity=5)Vollwelle(h=2.25,mitte=h-10,extrude=0,x0=-5,xCenter=-1);
   if(info)T(infoPos)mirror([1,0])Roof(.75,.5)Seg7(dia,h=7,ratio=.5,b=0.7,center=true,spiel=.45);
  }

 
  Tz(h/2)Polar(clips,lip,rot=180)R(0)RotEx(gradS(s=4,r=dia/2),center=true,fn=5)T(dia/2)Vollwelle(r=2,h=lip,l=h-5,mitte=0.5,extrude=0,x0=-2.0,xCenter=+1,grad=25);


Tz(h+h2-.001)Pille(rad,d=od,rad=[0,rad],center=false);
}



/** \name BallSocket
BallSocket() creates a ball and socket link
\param d ball diameter
\param spiel clearance
\param dist distance between center of ball socket
\param hole center hole
\param wand wall thickness
\param opt part
\param nozzleS orrifice for opt 1 nozzle
\param rad radii for opt 1 nozzle
\param deg  taper degree for opt 1 nozzle
\param closed close top for end caps
\param shortR squeezing the socket into ellipses
*/

//BallSocket();



module BallSocket(d=10,opt=0,dist=15,spiel=.08,hole=8,wand=.7,nozzleS=5,rad,deg,closed=false,shortR=.05,undercut=0.3,help){

part=[ 
 "link",       // 0
 "nozzle",    // 1 
 "base",     // 2
 "ball",    // 3
 "socket"  // 4 
];

info=false;

HelpTxt("BallSocket",["d",d,"opt",opt,"dist",dist,"spiel",spiel,"hole",hole,"wand",wand,"nozzleS",nozzleS,"rad",rad,"deg",deg,"closed",closed,"shortR",shortR,"undercut",undercut],help);

echo(opt=str(opt,"-",part[opt]),dist=dist);

;

Echo(str("hole too big max=",d-(undercut+wand)*2),color="redring",condition=hole>d-(undercut+(opt==0||opt==2||opt==3?wand:0) )*2);
Echo("dist too short",color="redring",condition=interSpace<wand);

angle=acos(1-undercut/(d/2));//15;
if(info)echo(angle=angle);


neckR=hole/2+wand;
socketR=d/2+spiel;
socketOR=socketR+wand;

lift=sin(angle)*d/2*(socketR-shortR)/socketR;
l=dist+lift;

interSpace=dist-Kathete(kat=neckR,hyp=socketOR)-Kathete(kat=neckR,hyp=d/2);

%if(opt==0&&interSpace>0)Tz(lift+Kathete(socketOR,neckR))color("chartreuse",.5)Ring(interSpace,d=hole+wand*2+0.05,id=hole+.01,$info=false);


  RotEx(cut=closed?true:false){
   Rund(wand/2.5,min(5,d/3,interSpace))difference(){
    union(){
      Rund(1,0)union(){
        T(y=l){
          if(opt==0||opt==2||opt==3)circle(d=d,$fn=0); // ball
          if(closed) circle(d=hole+wand*2,$fn=0);
          //rotate(-90)Tri(h=l,top=true,grad=49);
          
        }
        if(opt==0||opt==1||opt==4)square([d/2+spiel+wand+.25,2]); // bottom rim
        if(opt==0||opt==1||opt==4)T(y=lift)scale([1,(socketOR-shortR)/socketOR])circle(r=socketOR,$fn=0); // socket
        T(y=l/2)square([hole+wand*2,l],true); // neck tube
      }
      T(y=l/2)square([hole+wand*2,l],true); // neck tube
      if(opt==2)square([d/2,5]); // base tube
    }
    if(opt==0||opt==1||opt==4)T(y=lift)scale([1,(socketR-shortR)/socketR])circle(r=socketR,$fn=0); // ball cut
    T(-500+hole/2)square([1000,(closed?l:l+d)*2],true); // hole cut
    T(y=-500)square(1000,true);// bottom cut
    if(closed){
    //T(x=-500)square(1000,true);// side cut
    T(y=l)circle($fn=0,d=hole);
    }
    
    }
    

  }
if(opt==1)Tz(l -1){
echo(nozzleDiameter=nozzleS);
deg=is_undef(deg)?35:deg;
rad=is_undef(rad)?max(wand,abs(nozzleS-hole)):rad;
l2=abs(nozzleS-hole)/2/tan(deg)+rad + 1;
  Anschluss(h=l2,d1=hole,rad=rad,grad=deg,d2=nozzleS,wand=-wand,center=false);
  Tz(l2)Torus(dia=nozzleS+wand*2,d=wand);
  }

}










/** \name WaveWasher
\param od outer diameter
\param id inner diameter
\param h  height
\param a  wave amplitude
\param dicke thickness
\param f  number of waves
\param opt 1 vertical 2 radial
\param cutangle  bottom cut contact angle
\param fs fragment size
\param
*/

//WaveWasher(f=10,h=2,cutangle=0);

module WaveWasher(od=20,id=10,h=15,a=1,dicke=.6,f=3,opt=2,cutangle=30,fs=fs,name,help){

$info=false;
r=a*2;
e=round(h/(sin(45)*r));
hCenter=od/2- (cutangle?(1-cos(cutangle))*od/2:0);
fn=fs2fn(r=od/2,fs=fs,minf=f*10);

fn2=16;
f=f;//frequency
//a=r/2;//amplitude
loop=ceil(fn2/4)*4+4;


  points=[for(i=[0:fn])
  each mPoints(
  mPoints(quad([((od-id)/2),dicke],z=0,t=[(od+id)/4,0],fn=fn2),r=[sin(i*360/fn*f+90)*35*1,0])
  ,r=[0,(i*360/fn),0],t=[0,sin(i*360/fn*f)*a] )
  
  ];

 if(opt==1)difference(){
  $info=false;
  linear_extrude(od,convexity=5)Linear(e,es=sin(45)*r-dicke,center=true)mirror([$idx%2?0:1,0])Welle(e=ceil(od/(r*2))+1,grad=90,r=r,center=+1,rand=dicke,fs=fs);

  Tz(hCenter)R(90,z=90)linear_extrude(h*3,center=true)Tdrop(d=id);
  Tz(hCenter)R(y=90)Ring(d=od,rand=-50,h=h*3,center=true);
 }
  
 if(opt==2) 
    difference(){
      Tz(hCenter)Linear(h/a/2,y=1,es=a*2+0.01,center=true)Color($idx/(h/a/2))R(y=$idx%2?0:180/f)PolyH(points,loop=loop,end=0,flip=true);
   if(cutangle)   R(180)cylinder(50,d=500,$fn=6);
      }

  
HelpTxt("WaveWasher",["od",od,"id",id,"h",h,"a",a,"dicke",dicke,"f",f,"opt",opt,"cutangle",cutangle,"fs",fs,"name",name,],help);
}





/**
\name Hinge Box
HingeBox() creates 2 box halfs with hinges
\param size size [x,y,z]
\param wand wall thickness
\param hinges  number of hinges (optional)
\param lip  overlapping inner lip
\param pip  print in place clearance
\param pattern pattern number [bottom,top]
\param lid  optional for smaller lid heights
\param r1 corner radius (optional)
\param ir1 inner corner radius (optional)
\param r2 edge radius (optional)
\param ir2 inner edge radius (optional)
\param opt  select lower or upper half, 0 for both
\param opener grips to open  -1,0,1 
\param help help
*/

//HingeBox();

module HingeBox(size=[1,1,.5]*25,wand=.8,hinges,lip=true,pip=pip,pattern=[0,0],lid,r1,ir1,r2,ir2,opt=0,opener=false,bottom,name,help){

r1=r1?r1:min(size.xy/4); // corner radius
r2=r2?r2:1.5; // edge radius
ir1=max(.5,r1-wand,is_undef(ir1)?r1-wand:ir1); // inner corner radius
ir2=max(.5,r2-wand,is_undef(ir2)?r2-wand:ir2); // inner edge radius

hinges=hinges?hinges:max(1,round((size.y-r1*2)/((2.75+pip)*2)));

hingeD=5;
hingePin=hingeD/2;
hingePos=[hingeD/2+(pip?pip+.2:spiel),0,size.z/2];
if(!pip)echo(hinge_Hole=hingePin);
seg=hinges*2+1 ;
segL=(size.y-r1*2)/seg-pip;
sizeZ2=lid?lid:size.z/2;
bottom=is_undef(bottom)?wand:bottom;
latchL=min(size.y-(wand+ir1)*2,20);
lippe=[wand/2,is_num(lip)?lip:1.5]; // thickness, height

HelpTxt("HingeBox",["size",size,"wand",wand,"hinges",hinges,"lip",lip,"pip",pip,"pattern",pattern,"lid",lid,"r1",r1,"ir1",ir1,"r2",r2,"ir2",ir2,"opt",opt,"opener",opener,"bottom",bottom,"name",name],help);
InfoTxt("HingeBox",["InsideSize",[each(size.xy-[2,2]*wand),size.z/2+sizeZ2-bottom*2],"HingePos [x,z]",hingePos ],name);
union(){
$info=false;
Tz(!pip&&opt==2?-size.z/2+sizeZ2:0){

if(pip||opt==1)T(hingePos.x)BoxH(opt=1,pattern=pattern[0]);
if(pip||opt==2)Tz(size.z/2-sizeZ2)mirror([1,0])T(hingePos.x)BoxH([each size.xy,sizeZ2*2],opt=2,pattern=pattern[1]);

// Hinge
T(y=-size.y/2+pip/2+r1)Linear(seg,y=1,es=segL+pip)if(pip||(opt==1?!($idx%2):opt==2?$idx%2:false)){

    difference(){
      hull(){
        Tz(hingePos.z)R(-90)
          Pille(segL,d=hingeD,rad=.25,center=false);
        mirror([$idx%2?1:0,0,0])T(hingePos.x,z=($idx%2?r2+size.z/2-sizeZ2:r2))cube([.1,segL,($idx%2?sizeZ2:size.z/2)-r2-.5]);
      }
      if(pip&&$idx%2)Tz(hingePos.z)R(-90)Loch(segL,min(segL/3,hingePin/2.5),d=hingePin,rad=hingePin/4,cuts=0);
       else if(!pip) Tz(hingePos.z)R(90)linear_extrude(size.y*2,center=true,convexity=5)Tdrop(d=hingePin);
   }
}

}

// hingePin
if(pip)Linear(e=max(1,hinges),y=1,es=(segL+pip)*2,center=true)Tz(hingePos.z)R(-90)Loch(segL+pip*2,h2=min((segL+pip*2)/3,(hingePin)/2.5),d=hingePin-pip*2,rad=(hingePin-pip*2)/4,cuts=0,center=true);

}
  module BoxH(size=size,wand=wand,bottom=bottom,opt=0,latchPos=1.5,latchL=latchL,pattern=2,opener=opener,lippe=lippe){
  
  $info=false;
  //echo(size,opt);
    T(size.x/2)difference(){
      union(){
        Prisma(vMult(size,[1,1,.5]),r=r1,rad=r2,deg=[50,0]);
        if (opener){
      gY=size.y/2-r1;
      T(size.x/2-.5)mirror([0,opener==2||opener==-1?opt==1?0:1:opt==1?1:0,0])hull(){
        T(y=spiel,z=size.z/2)mirror([0,0,1])Prisma(4,gY,1,r=1,center=[0,0,0]);
        T(y=spiel,z=max(r2,size.z/2-4))cube([.1,max(gY-4,.5),.1]);
        }
      }
      }
      Tz(bottom)Prisma(size-[1,1,0]*wand*2,r=ir1,rad=ir2,deg=[90,0]);
//Pattern
     if(pattern)intersection(){
      if(pattern==1)HexGrid(e=[floor(size.x/4/sin(60))-1,ceil(size.y/4)+1],es=4)cylinder(.5,d=3,$fn=6,center=true);
      if(pattern==2)rotate(90)HexGrid(e=[floor(size.y/3/sin(60))-1,ceil(size.x/3.0)+1],es=3)Polar(3,rot=30)T(1.5/2-.1)cube([1.5,.5,.5],center=true);
      linear_extrude(100,center=true,convexity=5)Quad(size.xy-(r2+wand)*[2,2],rad=max(ir1-r2,0));
      }
// Latch groove
      if(opt==2){
        Tz(size.z/2-latchPos)R(90)LinEx(latchL-3,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=size.x/2-wand);
        T(size.x/2-wand -0.01,z=size.z/2+.01)R(-90)Kehle(l=latchL-2,center=true,end=2,rad=wand-n(1),fn2=4);
      }
    }
    
// Grip

    if(opt==2&&wand<1)T(size.x)Tz(size.z/2-latchPos)R(90)LinEx(latchL-2,end=true,center=true)Vollwelle(.5+wand,max(0.2,.5-wand),xCenter=-1,extrude=0,x0=-.1);// groove compensation
    if(!opener){
      if(size.z/2-r2<=8){if(opt==1)T(size.x)Tz(max(size.z/5,r2+1.0))R(90)LinEx(size.y-r1*2-2,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
      }
       else Tz(r2/2){
        if(opt==1)T(size.x)Tz(size.z/4)R(90)LinEx(size.y-r1*2 -7,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
          T(size.x)Tz(size.z/4)R(90)LinEx(size.y-r1*2-7.01,end=true,center=true)T(0,-3)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
          T(size.x)Tz(size.z/4+3)R(90)LinEx(size.y-r1*2-7,end=false,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
        }
    }
  //latch
    if(opt==1){
      intersection(){
        T(size.x-wand + (lip?-spiel-.001:0.01))Tz(size.z/2+latchPos-.15)R(90)LinEx(latchL-3,end=true,center=true)Vollwelle(.5-spiel,.5+spiel,xCenter=-1,extrude=0,x0=-wand+.1,l=20);
        T(size.x-wand-spiel)R(0,-90)linear_extrude(max(2,lippe[0]*2),center=true)Quad(size.z/2+2.25,latchL-.5,center=[0,1],rad=1);
        T(size.x-wand,z=size.z -1.99)R(90)cylinder(size.y,d=size.z,$fn=4,center=true);
      }
    }
    
   // lip
   
    if (lip&&opt==1)T(size.x/2,z=size.z/2-0.1){
      Tz(-.1)linear_extrude(lippe[1]+.1,convexity=5) Rand(-lippe[0])Quad(size.xy-(wand+spiel)*[2,2],r=max(0,ir1-spiel));
      Tz(-2)difference(){
        linear_extrude(2,convexity=5)difference(){
        //Rand(-lippe[0]-wand-spiel+.1)
          Quad(size.xy-.1*[2,2],r=r1-.1);
          Quad(size.xy-(lippe[0]+wand+spiel)*[2,2],r=max(0,ir1-lippe[0]-spiel));
        }
        Tz(-.001)Roof()Quad(size.xy-(wand-.1)*[2,2],r=ir1+.1,fn=50);
        }
      }
  }


}