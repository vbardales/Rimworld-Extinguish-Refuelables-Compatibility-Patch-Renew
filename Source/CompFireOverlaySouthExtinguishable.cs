using RimWorld;
using UnityEngine;
using Verse;

namespace ExtinguishRefuelablesPatch
{
    /// <summary>
    /// Medieval Overhaul's <c>CompProperties_FireOverlaySouth</c>, made extinguishable.
    /// </summary>
    /// <remarks>
    /// Extinguish Refuelables ships <c>ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable</c>,
    /// and everything else this mod patches uses it directly. Medieval Overhaul's stove and rustic
    /// hearth cannot: their comp draws the flame only while the building faces north, and swapping
    /// in the plain extinguishable comp would light a fire on the back of a stove turned away.
    ///
    /// So this reimplements the north-only rule on top of vanilla's own <see cref="CompFireOverlay"/>
    /// rather than on top of Medieval Overhaul's class. Deriving from the mod being patched would
    /// mean a compile-time reference to its assembly, and a type that fails to load for everyone
    /// who does not have it. Deriving from vanilla costs nothing and buys something as well:
    /// <c>Graphic_Flicker</c> finds any <see cref="CompFireOverlayBase"/> on the thing it is drawing
    /// and reads <c>FireSize</c> and <c>Props.DrawOffsetForRot</c> off it, so the def's own fireSize
    /// and offset keep working without this class touching them.
    /// </remarks>
    public class CompProperties_FireOverlaySouthExtinguishable : CompProperties_FireOverlay
    {
        public CompProperties_FireOverlaySouthExtinguishable()
        {
            compClass = typeof(CompFireOverlaySouthExtinguishable);
        }
    }

    public class CompFireOverlaySouthExtinguishable : CompFireOverlay
    {
        private CompFlickable flickableComp;

        private bool Burning =>
            (refuelableComp == null || refuelableComp.HasFuel)
            && (flickableComp == null || flickableComp.SwitchIsOn);

        public override void PostSpawnSetup(bool respawningAfterLoad)
        {
            // Vanilla's own PostSpawnSetup is what fetches refuelableComp.
            base.PostSpawnSetup(respawningAfterLoad);
            flickableComp = parent.GetComp<CompFlickable>();
        }

        public override void PostDraw()
        {
            // Deliberately not base.PostDraw(): vanilla draws the flame in every rotation.
            if (!Burning || parent.Rotation != Rot4.North)
            {
                return;
            }

            Vector3 drawPos = parent.DrawPos;
            drawPos.y += 3f / 74f;
            CompFireOverlay.FireGraphic.Draw(drawPos, Rot4.North, parent);
        }

        public override void CompTick()
        {
            // The growth timer starts the first tick the fire is actually alight. Medieval
            // Overhaul starts it on fuel alone, which would have a switched-off hearth grow to
            // full size in the dark and come back already at its end state.
            if (Burning && parent.Rotation == Rot4.North && startedGrowingAtTick < 0)
            {
                startedGrowingAtTick = GenTicks.TicksAbs;
            }
        }
    }
}
