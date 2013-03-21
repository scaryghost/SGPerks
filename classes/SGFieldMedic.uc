class SGFieldMedic extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum) {
    FinalInt= 500 * CurLevel;
    return Min(StatOther.RDamageHealedStat,FinalInt);
}

static function float GetSyringeChargeRate(KFPlayerReplicationInfo KFPRI) {
    return 3.00; // Level 6 - Recharges 200% faster
}

static function float GetHealPotency(KFPlayerReplicationInfo KFPRI) {
    return 1.75;  // Heals for 75% more
}

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI) {
    if ( KFGRI.GameDiff >= 5.0 ) {
        return 1.3; // Moves up to 20% faster
    }

    return 1.25; // Moves up to 25% faster
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster Instigator, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeVomit' ) {
        return float(InDamage) * 0.25; // 75% decrease in damage from Bloat's Bile
    }

    return InDamage;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if ( MP7MMedicGun(Other) != none || MP5MMedicGun(Other) != none || M7A3MMedicGun(Other) != none
        || KrissMMedicGun(Other) != none) {
        return 2.0; // 100% increase in Medic weapon ammo carry
    }

    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other) {
    if ( (MP7MAmmo(Other) != none || MP5MAmmo(Other) != none || M7A3MAmmo(Other) != none
        || KrissMAmmo(Other) != none ) ) {
        return 2.0; // 100% increase in Medic weapon ammo carry
    }

    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'Vest' ) {
        return 0.3;  // Up to 70% discount on Body Armor
    }
    else if ( Item == class'MP7MPickup' || Item == class'MP5MPickup' || Item == class'M7A3MPickup'
        || Item == class'KrissMPickup' ) {
        return 0.13;  // Up to 87% discount on Medic Gun
    }

    return 1.0;
}

static function float GetBodyArmorDamageModifier(KFPlayerReplicationInfo KFPRI) {
    return 0.25; // Level 6 - 75% Better Body Armor
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    P.ShieldStrength = 100;
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MP7MMedicGun", GetCostScaling(KFPRI, class'MP7MPickup'));
}

static function string GetCustomLevelInfo( byte Level) {
    return Default.CustomLevelInfo;
}

defaultproperties {
    PerkIndex=0

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Medic'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Medic_Gold'
    VeterancyName="Field Medic"
    Requirements(0)="Heal %x HP on your teammates"

    SRLevelEffects(0)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(1)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(2)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(3)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(4)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(5)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
    SRLevelEffects(6)="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"

    CustomLevelInfo="200% faster Syringe recharge|75% more potent healing|75% less damage from Bloat Bile|25% faster movement speed|100% larger Medic Gun clips|75% better Body Armor|70% discount on Body Armor|87% discount on Medic Guns|Grenades heal teammates and hurt enemies|Spawn with Body Armor and Medic Gun"
}
