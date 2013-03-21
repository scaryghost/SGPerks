class SGDemolitions extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum) {
    FinalInt= 500000 * CurLevel;
    return Min(StatOther.RExplosivesDamageStat,FinalInt);
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if (AmmoType == class'FragAmmo' || AmmoType == class'LAWAmmo') {
        // Up to 6 extra Grenades
        return 2.2;
    }
    else if (AmmoType == class'PipeBombAmmo') {
        // Up to 6 extra for a total of 8 Remote Explosive Devices
        return 4.0;
    }
    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
         class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none
         || class<DamTypeM203Grenade>(DmgType) != none || class<DamTypeRocketImpact>(DmgType) != none ) {
        return float(InDamage) * 1.6; //  Up to 60% extra damage
    }

    return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster Instigator, int InDamage, class<DamageType> DmgType) {
    if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
         class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none
         || class<DamTypeM203Grenade>(DmgType) != none || class<DamTypeRocketImpact>(DmgType) != none ) {
        return float(InDamage) * 0.4;
    }

    return InDamage;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'PipeBombPickup' ) {
        // Todo, this won't need to be so extreme when we set up the system to only allow him to buy it perhaps
        return 0.26; // Up to 74% discount on PipeBomb(changed to 68% in Balance Round 1, upped to 74% in Round 4)
    }
    else if ( Item == class'M79Pickup' || Item == class 'M32Pickup'
        || Item == class 'LawPickup' || Item == class 'M4203Pickup'
        || Item == class'GoldenM79Pickup' ) {
        return 0.30; // Up to 70% discount on M79/M32
    }

    return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'PipeBombPickup' ) {
        return 0.26; // Up to 74% discount on PipeBomb(changed to 68% in Balance Round 3, upped to 74% in Round 4)
    }
    else if ( Item == class'M79Pickup' || Item == class'M32Pickup'
        || Item == class'LAWPickup' || Item == class'M4203Pickup'
        || Item == class'GoldenM79Pickup' ) {
        return 0.7; // Up to 30% discount on Grenade Launcher and LAW Ammo(Balance Round 5)
    }

    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.PipeBombExplosive", GetCostScaling(KFPRI, class'PipeBombPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
}

defaultproperties {
    PerkIndex=6

    OnHUDIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition_Gold'
    VeterancyName="Demolitions"
    Requirements(0)="Deal %x damage with the Explosives"

    SRLevelEffects(0)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(1)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(2)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(3)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(4)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(5)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
    SRLevelEffects(6)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"

    CustomLevelInfo="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|74% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
}
