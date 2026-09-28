using System.Linq;
using RimWorks.Pickle;
using RimWorld;
using Verse;

namespace ExtinguishRefuelablesPatch.PickleSteps
{
    /// <summary>
    /// What the patched buildings show once the game has built them: the switch, the state of the
    /// switch, the overlay class the def ended up with, and the way a spawned building faces.
    ///
    /// Every pattern starts with "Extinguish Refuelables Patch:". Pickle loads the steps of every
    /// installed suite into one namespace, and a repeated text is an "Ambiguous step" that fails
    /// healthy scenarios.
    /// </summary>
    [PickleSteps]
    public class PatchSteps
    {
        // The classes an overlay may end up as once this mod has patched it, and the ones that would
        // mean the swap did not happen.
        private static readonly string[] Swapped =
        {
            "ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable",
            "ExtinguishRefuelables.CompProperties_DarklightOverlayExtinguishable",
            "ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable",
        };

        private static readonly string[] Unswapped =
        {
            "RimWorld.CompProperties_FireOverlay",
            "RimWorld.CompProperties_DarklightOverlay",
            "MedievalOverhaul.CompProperties_FireOverlaySouth",
        };

        private static Thing ThingAt(PickleContext ctx, string defName, int x, int z)
        {
            Map map = Find.CurrentMap;
            ctx.Assert(map != null, "no map is loaded");
            IntVec3 cell = new IntVec3(x, 0, z);
            ctx.Assert(cell.InBounds(map), $"cell ({x}, {z}) is outside the map, which is {map.Size.x} by {map.Size.z}");
            Thing thing = cell.GetThingList(map).FirstOrDefault(t => t.def.defName == defName);
            ctx.Assert(thing != null,
                $"no {defName} at ({x}, {z}); the cell holds: "
                + string.Join(", ", cell.GetThingList(map).Select(t => t.def.defName)));
            return thing;
        }

        private static CompFlickable SwitchOf(PickleContext ctx, Thing thing)
        {
            CompFlickable flickable = thing.TryGetComp<CompFlickable>();
            ctx.Assert(flickable != null, $"{thing.def.defName} has no CompFlickable, so no on/off switch");
            return flickable;
        }

        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) has an on/off switch")]
        public void HasSwitch(PickleContext ctx, string defName, int x, int z)
        {
            SwitchOf(ctx, ThingAt(ctx, defName, x, z));
        }

        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) has exactly one on/off switch")]
        public void HasOneSwitch(PickleContext ctx, string defName, int x, int z)
        {
            Thing thing = ThingAt(ctx, defName, x, z);
            ThingWithComps withComps = thing as ThingWithComps;
            ctx.Assert(withComps != null, $"{defName} carries no comps at all");
            int count = withComps.AllComps.Count(c => c is CompFlickable);
            ctx.Assert(count == 1, $"{defName} has {count} CompFlickable, expected exactly one");
        }

        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) is switched {word}")]
        public void IsSwitched(PickleContext ctx, string defName, int x, int z, string state)
        {
            bool wantOn = ParseState(ctx, state);
            CompFlickable flickable = SwitchOf(ctx, ThingAt(ctx, defName, x, z));
            ctx.Assert(flickable.SwitchIsOn == wantOn,
                $"{defName} at ({x}, {z}) is switched {(flickable.SwitchIsOn ? "on" : "off")}, expected {state}");
        }

        [When("Extinguish Refuelables Patch: I switch the {string} at ({int}, {int}) {word}")]
        public void Switch(PickleContext ctx, string defName, int x, int z, string state)
        {
            bool wantOn = ParseState(ctx, state);
            SwitchOf(ctx, ThingAt(ctx, defName, x, z)).SwitchIsOn = wantOn;
        }

        [When("Extinguish Refuelables Patch: I rotate the {string} at ({int}, {int}) to {word}")]
        public void Rotate(PickleContext ctx, string defName, int x, int z, string direction)
        {
            Rot4 rot = Rot4.FromString(direction);
            Thing thing = ThingAt(ctx, defName, x, z);
            ctx.Assert(thing.def.rotatable, $"{defName} is not rotatable");
            thing.Rotation = rot;
        }

        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) faces {word}")]
        public void Faces(PickleContext ctx, string defName, int x, int z, string direction)
        {
            Rot4 want = Rot4.FromString(direction);
            Thing thing = ThingAt(ctx, defName, x, z);
            ctx.Assert(thing.Rotation == want, $"{defName} at ({x}, {z}) faces {thing.Rotation}, expected {want}");
        }

        [Then("Extinguish Refuelables Patch: the def {string} draws its fire with an extinguishable overlay")]
        public void DrawsWithExtinguishable(PickleContext ctx, string defName)
        {
            ThingDef def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Assert(def != null, $"no ThingDef {defName}");
            string[] classes = def.comps.Select(c => c.GetType().FullName).ToArray();
            ctx.Assert(classes.Any(c => Swapped.Contains(c)),
                $"{defName} has no extinguishable overlay; its comp properties are: {string.Join(", ", classes)}");
            ctx.Assert(!classes.Any(c => Unswapped.Contains(c)),
                $"{defName} still carries an unswapped overlay; its comp properties are: {string.Join(", ", classes)}");
        }


        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) has {int} on/off switches")]
        public void HasSwitchCount(PickleContext ctx, string defName, int x, int z, int expected)
        {
            int count = CountSwitches(ctx, ThingAt(ctx, defName, x, z));
            ctx.Assert(count == expected, $"{defName} has {count} CompFlickable, expected {expected}");
        }

        [Then("Extinguish Refuelables Patch: the {string} at ({int}, {int}) has no on/off switch")]
        public void HasNoSwitch(PickleContext ctx, string defName, int x, int z)
        {
            int count = CountSwitches(ctx, ThingAt(ctx, defName, x, z));
            ctx.Assert(count == 0, $"{defName} has {count} CompFlickable, expected none");
        }

        // Takes the switch comp off a standing building, so a save made right after holds none of its
        // state: the same file a game without this mod would have written. Reloading it with the mod
        // active is then the case of adding the mod to a save in progress.
        [When("Extinguish Refuelables Patch: I strip the on/off switch from the {string} at ({int}, {int})")]
        public void StripSwitch(PickleContext ctx, string defName, int x, int z)
        {
            ThingWithComps withComps = ThingAt(ctx, defName, x, z) as ThingWithComps;
            ctx.Assert(withComps != null, $"{defName} carries no comps at all");
            int removed = withComps.AllComps.RemoveAll(c => c is CompFlickable);
            ctx.Assert(removed > 0, $"{defName} had no CompFlickable to strip");
        }

        // Reads one field of the swapped fire overlay's comp properties, by name, as text. The swapped
        // classes are not all descended from vanilla's CompProperties_FireOverlay, so the field is read
        // by reflection rather than by a cast.
        [Then("Extinguish Refuelables Patch: the def {string} fire overlay field {string} is {string}")]
        public void OverlayField(PickleContext ctx, string defName, string field, string expected)
        {
            ThingDef def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Assert(def != null, $"no ThingDef {defName}");
            CompProperties props = def.comps.FirstOrDefault(c => Swapped.Contains(c.GetType().FullName));
            ctx.Assert(props != null, $"{defName} has no extinguishable overlay");
            System.Reflection.FieldInfo info = props.GetType().GetField(field,
                System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic
                | System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.FlattenHierarchy);
            ctx.Assert(info != null, $"{props.GetType().FullName} has no field {field}");
            string actual = System.Convert.ToString(info.GetValue(props), System.Globalization.CultureInfo.InvariantCulture);
            ctx.Assert(actual == expected, $"{defName} overlay {field} is {actual}, expected {expected}");
        }

        private static int CountSwitches(PickleContext ctx, Thing thing)
        {
            ThingWithComps withComps = thing as ThingWithComps;
            ctx.Assert(withComps != null, $"{thing.def.defName} carries no comps at all");
            return withComps.AllComps.Count(c => c is CompFlickable);
        }

        private static bool ParseState(PickleContext ctx, string state)
        {
            bool on = state == "on";
            ctx.Assert(on || state == "off", $"the state is \"on\" or \"off\", not \"{state}\"");
            return on;
        }
    }
}
