class SGFirebug extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum) {
    FinalInt= 100000 * CurLevel;
    return Min(StatOther.RFlameThrowerDamageStat,FinalInt);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if (Flamethrower(Other) != none || MAC10MP(Other) != none) {
        return 1.6; // Up to 60% larger fuel canister
    }
    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if (FlameAmmo(Other) != none || MAC10Ammo(Other) != none || HuskGunAmmo(Other) != none || 
            TrenchgunAmmo(Other) != none || FlareRevolverAmmo(Other) != none) {
        return 1.6; // Up to 60% larger fuel canister
    }

    return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FlameAmmo' || AmmoType == class'MAC10Ammo' || AmmoType == class'HuskGunAmmo' || 
        AmmoType == class'TrenchgunAmmo' || AmmoType == class'FlareRevolverAmmo') {
        return 1.6; // Up to 60% larger fuel canister
    }

    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeBurned>(DmgType) != none || class<DamTypeFlamethrower>(DmgType) != none
        || class<DamTypeHuskGunProjectileImpact>(DmgType) != none || class<DamTypeFlareProjectileImpact>(DmgType) != none ) {
        return float(InDamage) * 1.6; //  Up to 60% extra damage
    }

    return InDamage;
}

// Change effective range on FlameThrower
static function int ExtraRange(KFPlayerReplicationInfo KFPRI) {
    return 2; // 100% Longer Range
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster Instigator, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeBurned>(DmgType) != none || class<DamTypeFlamethrower>(DmgType) != none
        || class<DamTypeHuskGunProjectileImpact>(DmgType) != none || class<DamTypeFlareProjectileImpact>(DmgType) != none ) {
        return 0; // 100% reduction in damage from fire
    }

    return InDamage;
}

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI) {
    return class'FlameNade'; // Grenade detonations cause enemies to catch fire
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( Flamethrower(Other) != none || MAC10MP(Other) != none || Trenchgun(Other) != none || 
        FlareRevolver(Other) != none || DualFlareRevolver(Other) != none) {
        return 1.6; // Up to 60% faster reload with Flamethrower
    }

    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'FlameThrowerPickup' || Item == class'MAC10Pickup'
        || Item == class'HuskGunPickup' || Item == class'TrenchgunPickup' || Item == class'FlareRevolverPickup'
        || Item == class'DualFlareRevolverPickup' ) {
        return 0.3; // Up to 70% discount on Flame Weapons
    }

    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.FlameThrower", GetCostScaling(KFPRI, class'FlamethrowerPickup'));
    P.ShieldStrength = 100;
}

static function class<DamageType> GetMAC10DamageType(KFPlayerReplicationInfo KFPRI) {
    return class'DamTypeMAC10MPInc';
}

defaultproperties {
    PerkIndex=5

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Firebug'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Firebug_Gold'
    VeterancyName="Firebug"
    Requirements(0)="Deal %x damage with the flame weapons"

    SRLevelEffects(0)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(1)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(2)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(3)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(4)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(5)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    SRLevelEffects(6)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
    
    CustomLevelInfo="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
}
