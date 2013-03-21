class SGCommando extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum) {
    if (ReqNum == 0) {
        FinalInt= 70 * CurLevel;
        return Min(StatOther.RStalkerKillsStat,FinalInt);
    }
    FinalInt= 100000 * CurLevel;
    return Min(StatOther.RBullpupDamageStat,FinalInt);
}

static function SpecialHUDInfo(KFPlayerReplicationInfo KFPRI, Canvas C) {
    local KFMonster KFEnemy;
    local HUDKillingFloor HKF;
    local float MaxDistance;

    HKF= HUDKillingFloor(C.ViewPort.Actor.myHUD);
    if (HKF == none || Pawn(C.ViewPort.Actor.ViewTarget)==none || Pawn(C.ViewPort.Actor.ViewTarget).Health<=0)
        return;

    MaxDistance = 800; // 100% (800 units)

    foreach C.ViewPort.Actor.VisibleCollidingActors(class'KFMonster',KFEnemy,MaxDistance,C.ViewPort.Actor.CalcViewLocation) {
        if ( KFEnemy.Health > 0 && !KFEnemy.Cloaked() ) {
            HKF.DrawHealthBar(C, KFEnemy, KFEnemy.Health, KFEnemy.HealthMax , 50.0);
        }
    }
}

static function bool ShowStalkers(KFPlayerReplicationInfo KFPRI) {
    return true;
}

static function float GetStalkerViewDistanceMulti(KFPlayerReplicationInfo KFPRI) {
    return 1.0; // 100% of Standard Distance(800 units or 16 meters)
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( (Bullpup(Other) != none || AK47AssaultRifle(Other) != none ||
        SCARMK17AssaultRifle(Other) != none || M4AssaultRifle(Other) != none
        || FNFAL_ACOG_AssaultRifle(Other) != none || MKb42AssaultRifle(Other) != none
        || ThompsonSMG(Other) != none )) {
        return 1.25; // 25% increase in assault rifle ammo carry
    }

    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if ( (BullpupAmmo(Other) != none || AK47Ammo(Other) != none ||
        SCARMK17Ammo(Other) != none || M4Ammo(Other) != none
        || FNFALAmmo(Other) != none || MKb42Ammo(Other) != none
        || ThompsonAmmo(Other) != none || GoldenAK47Ammo(Other) != none)) {
        return 1.25; // 25% increase in assault rifle ammo carry
    }

    return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( (AmmoType == class'BullpupAmmo' || AmmoType == class'AK47Ammo' ||
        AmmoType == class'SCARMK17Ammo' || AmmoType == class'M4Ammo'
        || AmmoType == class'FNFALAmmo' || AmmoType == class'MKb42Ammo'
        || AmmoType == class'ThompsonAmmo' || AmmoType == class'GoldenAK47Ammo')) {
        return 1.25; // 25% increase in assault rifle ammo carry
    }

    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeBullpup' || DmgType == class'DamTypeAK47AssaultRifle' ||
        DmgType == class'DamTypeSCARMK17AssaultRifle' || DmgType == class'DamTypeM4AssaultRifle'
        || DmgType == class'DamTypeFNFALAssaultRifle' || DmgType == class'DamTypeMKb42AssaultRifle'
        || DmgType == class'DamTypeThompson' ) {
        return float(InDamage) * 1.50; // Up to 50% increase in Damage with Bullpup
    }

    return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    if ( Bullpup(Other.Weapon) != none || AK47AssaultRifle(Other.Weapon) != none ||
        SCARMK17AssaultRifle(Other.Weapon) != none || M4AssaultRifle(Other.Weapon) != none
        || FNFAL_ACOG_AssaultRifle(Other.Weapon) != none || MKb42AssaultRifle(Other.Weapon) != none
        || ThompsonSMG(Other.Weapon) != none ) {
            Recoil = 0.60; // Level 6 - 40% recoil reduction
    } else {
        Recoil = 1.0;
    }
    return Recoil;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    return 1.35; // Up to 35% faster reload speed
}


// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
    return 4;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'BullpupPickup' || Item == class'AK47Pickup' ||
        Item == class'SCARMK17Pickup' || Item == class'M4Pickup'
        || Item == class'FNFAL_ACOG_Pickup' || Item == class'MKb42Pickup'
        || Item == class'ThompsonPickup' || Item == class'GoldenAK47Pickup') {
        return 0.3; // Up to 70% discount on Assault Rifles
    }
    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.AK47AssaultRifle", GetCostScaling(KFPRI, class'AK47Pickup'));
}

static function string GetCustomLevelInfo( byte Level) {
    return Default.CustomLevelInfo;
}

defaultproperties {
    PerkIndex=3

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Commando'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Commando_Gold'
    VeterancyName="Commando"
    Requirements(0)="Kill %x Stalkers with Assault/Battle Rifles"
    Requirements(1)="Deal %x damage with Assault/Battle Rifles"
    NumRequirements=2

    SRLevelEffects(0)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(1)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(2)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(3)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(4)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(5)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
    SRLevelEffects(6)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"

    CustomLevelInfo="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
}
