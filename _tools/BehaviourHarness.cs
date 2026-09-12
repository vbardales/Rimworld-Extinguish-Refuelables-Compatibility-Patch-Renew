// Minimal test doubles, not a simulation of RimWorld or Unity.
namespace UnityEngine { public struct Vector3 { public float x,y,z; } }
namespace Verse {
 public enum Rot4 { North, East, South, West }
 public static class GenTicks { public static int TicksAbs; }
 public class Thing {
  public Rot4 Rotation; public UnityEngine.Vector3 DrawPos;
  public RimWorld.CompFlickable Flick; public RimWorld.CompRefuelable Fuel;
  public T GetComp<T>() where T:class { return typeof(T)==typeof(RimWorld.CompFlickable)?Flick as T:Fuel as T; }
 }
 public class Graphic {
  public int Calls; public UnityEngine.Vector3 Last;
  public void Draw(UnityEngine.Vector3 pos, Rot4 rot, Thing thing) { Calls++; Last=pos; }
 }
}
namespace RimWorld {
 public class CompFlickable { public bool SwitchIsOn; }
 public class CompRefuelable { public bool HasFuel; }
 public class CompProperties_FireOverlay { public System.Type compClass; }
 public class CompFireOverlay {
  public Verse.Thing parent; protected CompRefuelable refuelableComp;
  protected int startedGrowingAtTick=-1;
  public int Started { get { return startedGrowingAtTick; } }
  public static Verse.Graphic FireGraphic=new Verse.Graphic();
  public virtual void PostSpawnSetup(bool reload) { refuelableComp=parent.GetComp<CompRefuelable>(); }
  public virtual void PostDraw() { throw new System.Exception("Base draw must not be called"); }
  public virtual void CompTick() { throw new System.Exception("Base tick must not be called"); }
 }
}
public static class BehaviourHarness {
 static void Check(bool ok,string message) { if(!ok)throw new System.Exception(message); }
 public static int Run() {
  int cases=0;
  foreach(bool reload in new[]{false,true}) foreach(int fuel in new[]{-1,0,1})
  foreach(int flick in new[]{-1,0,1}) foreach(Verse.Rot4 rot in System.Enum.GetValues(typeof(Verse.Rot4))) {
   var thing=new Verse.Thing { Rotation=rot, DrawPos=new UnityEngine.Vector3{x=2,y=3,z=4},
    Fuel=fuel<0?null:new RimWorld.CompRefuelable{HasFuel=fuel==1},
    Flick=flick<0?null:new RimWorld.CompFlickable{SwitchIsOn=flick==1} };
   var comp=new ExtinguishRefuelablesPatch.CompFireOverlaySouthExtinguishable{parent=thing};
   comp.PostSpawnSetup(reload); RimWorld.CompFireOverlay.FireGraphic.Calls=0;
   Verse.GenTicks.TicksAbs=123; comp.CompTick(); comp.PostDraw();
   bool lit=fuel!=0 && flick!=0 && rot==Verse.Rot4.North;
   Check(RimWorld.CompFireOverlay.FireGraphic.Calls==(lit?1:0),"Wrong flame visibility");
   Check(comp.Started==(lit?123:-1),"Wrong growth start");
   if(lit)Check(System.Math.Abs(RimWorld.CompFireOverlay.FireGraphic.Last.y-(3f+3f/74f))<.00001f,"Wrong height offset");
   if(thing.Fuel!=null)thing.Fuel.HasFuel=true;
   if(thing.Flick!=null)thing.Flick.SwitchIsOn=true;
   thing.Rotation=Verse.Rot4.North; Verse.GenTicks.TicksAbs=456;
   comp.CompTick(); Check(comp.Started==(lit?123:456),"Timer restarted or failed to start on relight");
   comp.PostSpawnSetup(true); Verse.GenTicks.TicksAbs=789; comp.CompTick();
   Check(comp.Started==(lit?123:456),"Spawn setup reset existing timer"); cases++;
  }
  Check(new ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable().compClass==typeof(ExtinguishRefuelablesPatch.CompFireOverlaySouthExtinguishable),"Wrong comp binding");
  return cases;
 }
}
