// ============================================================
//  Pi 5 + Waveshare 7" DSI LCD (with Camera)
//  "Armor" dashboard casing.   v3 (open-top pod + vent lid)
//  THREE parts:  face (screen open) + back (Pi pod) + lid (vent cap)
//    part = "face" | "back" | "lid" | "both" | "fit"
//
//  PRINT (ASA/ABS — hot cabin melts PLA; brim on):
//    FACE -> front-face-down (lip = first layer, no support)
//    BACK -> plate-down / pod-up  (open top + U-slot ports = NO bridges)
//    LID  -> flat  (vent holes print perfectly)
//  Assembly: heat-set M3 inserts in FACE ears; screw from BACK.
//            LID press-fits into the pod-top rabbet. 1mm foam on blue board.
//
//  STILL NEEDS: camera module body size (face pocket), standoff height.
// ============================================================
part = "back";

/* ---------- CONFIRMED display glass ---------- */
board_w = 192.96;  board_h = 110.76;
view_w  = 154.88;  view_h  = 86.72;
view_x  = 19.04;   view_y  = 11.00;
cam_x   = 183.0;   cam_y   = 55.4;   cam_d = 9;   // lens aperture (was 8, widened)
cam_body   = 15;   // # OV5647 module body clearance (holder ~8.5mm + margin)
cam_relief = 2.2;  // interior pocket depth into the front plate
cam_fpc_w  = 10;   // FPC channel width (camera -> right edge -> wraps to back)

/* ---------- MEASURED build depths ---------- */
disp_th   = 5;   blue_step = 8;
module_th = disp_th + blue_step;   // 13
pi_stack  = 34;  pod_clear = 6;
pod_depth = pi_stack + pod_clear;  // 40
port_z0 = 15;    port_h = 20;

/* ---------- Pi/cooler POD (landscape, centered) ---------- */
pod_w  = 96;   pod_l = 68;
pod_x0 = (board_w - pod_w)/2;
pod_y0 = (board_h - pod_l)/2;

/* ---------- lid rabbet ---------- */
seat_d = 3.5;    // lid thickness / seat depth
ledge  = 1.5;    // ledge width the lid rests on
TOP    = pod_depth + seat_d;        // pod wall top

/* ---------- shell tuning ---------- */
clear  = 1.5;   wall = 3;
lip_th = 3.2;   corner = 7;   $fn = 64;

/* ---------- fastening (face<->back) ---------- */
boss_d = 9;  ins_d = 4.2;  screw_d = 3.4;  head_d = 6;
cx = 96.48; cy = 55.38;
screw_pts = [[-7.5,-7.5],[200.5,-7.5],[-7.5,118.3],[200.5,118.3],[cx,-7.5],[cx,118.3]];

/* ---------- derived ---------- */
wrap_h = lip_th + module_th;        // 16.2
iw = board_w + clear*2;  ih = board_h + clear*2;
ow = iw + wall*2;        oh = ih + wall*2;

module rbox(l,w,h,r){ hull() for(x=[r,l-r],y=[r,w-r]) translate([x,y,0]) cylinder(r=r,h=h); }
module ear_solid(pt,h){
  v=[cx-pt[0], cy-pt[1]];  L=norm(v);
  a=[pt[0]+v[0]/L*13, pt[1]+v[1]/L*13];
  hull(){ translate([pt[0],pt[1],0]) cylinder(d=boss_d,h=h);
          translate([a[0],a[1],0])   cylinder(d=boss_d,h=h); }
}

/* ================= FACEPLATE ================= */
module face(){
  difference(){
    union(){
      translate([-wall-clear,-wall-clear,0]) rbox(ow,oh,wrap_h,corner);
      for(p=screw_pts) ear_solid(p,wrap_h);
    }
    translate([-clear,-clear,lip_th]) cube([iw,ih,wrap_h]);
    translate([view_x-0.5,view_y-0.5,-1]) cube([view_w+1,view_h+1,lip_th+2]);
    translate([cam_x,cam_y,-1]) cylinder(d=cam_d,h=lip_th+2);                    // lens aperture
    translate([cam_x,cam_y,lip_th-cam_relief]) cylinder(d=cam_body,h=cam_relief+0.1); // module pocket
    translate([cam_x,cam_y-cam_fpc_w/2,lip_th-cam_relief])                       // FPC exit channel
      cube([board_w-cam_x+wall+clear+2,cam_fpc_w,cam_relief+0.1]);
    for(p=screw_pts) translate([p[0],p[1],wrap_h-7]) cylinder(d=ins_d,h=7.1);
  }
}

/* ================= ARMOR BACK (open-top Pi pod) ================= */
module back(){
  difference(){
    union(){
      translate([-wall-clear,-wall-clear,0]) rbox(ow,oh,wall,corner);            // back plate
      translate([pod_x0-wall,pod_y0-wall,0]) rbox(pod_w+2*wall,pod_l+2*wall,TOP,corner); // pod walls
      for(p=screw_pts) ear_solid(p,6);
      translate([2,board_h/2-3,0]) cube([6,6,10]);                               // ribbon-tie anchor
    }
    translate([pod_x0,pod_y0,-1]) cube([pod_w,pod_l,TOP+2]);                      // hollow (open top)
    translate([pod_x0-ledge,pod_y0-ledge,TOP-seat_d]) cube([pod_w+2*ledge,pod_l+2*ledge,seat_d+1]); // lid seat
    // U-slot PORT BAYS (open to the rim -> no lintel bridge)
    translate([pod_x0+10,pod_y0-wall-2,port_z0]) cube([pod_w-20,wall+6,TOP-port_z0+2]);   // front: 4xUSB+Eth
    translate([pod_x0-wall-2,pod_y0+6,port_z0])  cube([wall+6,38,TOP-port_z0+2]);         // LEFT: USB-C+HDMI
    translate([-wall-clear-1,board_h/2-16,0]) cube([wall+4,32,pod_depth]);                // ribbon slot
    for(p=screw_pts){
      translate([p[0],p[1],-1]) cylinder(d=screw_d,h=8);
      translate([p[0],p[1],3]) cylinder(d=head_d,h=4);
    }
  }
}

/* ================= VENT LID (prints flat) ================= */
module lid(){
  lw = pod_w+2*ledge-0.4;  ll = pod_l+2*ledge-0.4;
  ox = pod_x0-ledge+0.2;   oy = pod_y0-ledge+0.2;
  difference(){
    translate([ox,oy,0]) rbox(lw,ll,seat_d,corner-2);
    for(ix=[0:9],iy=[0:6]) translate([ox+9+ix*8,oy+8+iy*8,-1]) cylinder(d=5,h=seat_d+2);
  }
}

/* ================= HARDWARE MOCK ================= */
module hardware(){
  z0=lip_th;
  color("dimgray")  translate([0,0,z0]) cube([board_w,board_h,disp_th]);
  color("royalblue")translate([13.98,4.88,z0+module_th-1.6]) cube([165,101,1.6]);
  color("green")    translate([pod_x0+5,pod_y0+6,z0+module_th+15]) cube([85,56,1.6]);
  color("silver")   translate([pod_x0+28,pod_y0+18,z0+module_th+17]) cube([40,40,15]);
}

/* ================= render selector ================= */
if(part=="face") face();
else if(part=="back") back();
else if(part=="lid") lid();
else if(part=="both"){
  face();
  translate([0,0,wrap_h+55]) back();
  translate([0,0,wrap_h+55+TOP-seat_d+40]) lid();
}
else if(part=="fit"){
  difference(){
    union(){
      face();
      translate([0,0,wrap_h]) back();
      translate([0,0,wrap_h+TOP-seat_d]) lid();
      hardware();
    }
    translate([-40,board_h/2,-20]) cube([board_w+80,board_h,TOP+80]);
  }
}
