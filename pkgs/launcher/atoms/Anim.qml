import QtQuick
import "../theme"

NumberAnimation {
    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial,
        FastEffects,
        DefaultEffects,
        SlowEffects
    }

    property int type: Anim.DefaultSpatial

    duration: {
        const d = Tokens.anim.durations;
        switch (type) {
        case Anim.FastSpatial:
            return d.expressiveFastSpatial;
        case Anim.DefaultSpatial:
            return d.expressiveDefaultSpatial;
        case Anim.SlowSpatial:
            return d.expressiveSlowSpatial;
        case Anim.FastEffects:
            return d.expressiveFastEffects;
        case Anim.DefaultEffects:
            return d.expressiveDefaultEffects;
        case Anim.SlowEffects:
            return d.expressiveSlowEffects;
        }
        return d[["small", "normal", "large", "extraLarge"][type % 4]];
    }

    easing.type: Easing.BezierSpline
    easing.bezierCurve: {
        const c = Tokens.anim.curves;
        switch (type) {
        case Anim.FastSpatial:
            return c.expressiveFastSpatial;
        case Anim.DefaultSpatial:
            return c.expressiveDefaultSpatial;
        case Anim.SlowSpatial:
            return c.expressiveSlowSpatial;
        case Anim.FastEffects:
            return c.expressiveFastEffects;
        case Anim.DefaultEffects:
            return c.expressiveDefaultEffects;
        case Anim.SlowEffects:
            return c.expressiveSlowEffects;
        }
        if (type >= Anim.EmphasizedSmall && type <= Anim.EmphasizedExtraLarge)
            return c.emphasized;
        return c.standard;
    }
}
