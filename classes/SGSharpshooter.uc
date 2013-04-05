class SGSharpshooter extends SRVeterancyTypes
    abstract;

// Removed all General Damage additions for the Sharpshooter in Balance Round 6 in favor of a headshot focus
//static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    FinalInt= 3000 * CurLevel;
    return Min(StatOther.RHeadshotKillsStat,FinalInt);
}

static function float GetHeadShotDamMulti(KFPlayerReplicationInfo KFPRI, KFPawn P, class<DamageType> DmgType) {
    local float ret;

    // Removed extra SS Crossbow headshot damage in Round 1(added back in Round 2) and Removed Single/Dualies Damage for Hell on Earth in Round 6
    // Added Dual Deagles back in for Balance Round 7
    if ( DmgType.name == 'DamTypeCrossbow' || DmgType.name == 'DamTypeCrossbowHeadShot' || DmgType.name == 'DamTypeWinchester' ||
         DmgType.name == 'DamTypeDeagle' || DmgType.name == 'DamTypeDualDeagle' || DmgType.name == 'DamTypeM14EBR' ||
          DmgType.name == 'DamTypeMagnum44Pistol' || DmgType.name == 'DamTypeDual44Magnum'
          || DmgType.name == 'DamTypeMK23Pistol' || DmgType.name == 'DamTypeDualMK23Pistol'
          || DmgType.name == 'DamTypeM99SniperRifle' || DmgType.name == 'DamTypeM99HeadShot' ||
         (DmgType.name == 'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty < 7.0) || DmgType.name == 'DamTypeHuntingRifle') {
        ret = 1.60; // 60% increase in Crossbow/Winchester/Handcannon damage
    }
    // Reduced extra headshot damage for Single/Dualies in Hell on Earth difficulty(added in Balance Round 6)
    else if ( DmgType == class'DamTypeDualies' && KFPRI.Level.Game.GameDifficulty >= 7.0 ) {
        return 1.4; // 40% increase in Headshot Damage
    }
    else {
        ret = 1.0; // Fix for oversight in Balance Round 6(which is the reason for the Round 6 second attempt patch)
    }

    return ret * 1.5; // 50% increase in Headshot Damage
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil) {
    if (Other.Weapon.IsA('Crossbow') || Other.Weapon.IsA('Winchester') || Other.Weapon.IsA('Single') || Other.Weapon.IsA('Dualies') || 
        Other.Weapon.IsA('Deagle') || Other.Weapon.IsA('DualDeagle') || Other.Weapon.IsA('M14EBRBattleRifle') || Other.Weapon.IsA('M99SniperRifle') || 
        Other.Weapon.IsA('HUNTING_RIFLE')) {
            Recoil = 0.25; // 75% recoil reduction with Crossbow/Winchester/Handcannon
    } else {
        Recoil = 1.0;
    }
    Return Recoil;
}

// Modify fire speed
static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other) {
    if (Other.IsA('Winchester') || Other.IsA('Crossbow') || Other.IsA('M99SniperRifle') || Other.IsA('HUNTING_RIFLE')) {
        return 1.6; // Up to 60% faster fire rate with Winchester
    }
    return 1.0;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) {
    if (Other.IsA('Winchester') || Other.IsA('Single') || Other.IsA('Dualies') || 
        Other.IsA('Deagle') || Other.IsA('DualDeagle') || Other.IsA('M14EBRBattleRifle') || Other.IsA('MK23Pistol') || 
        Other.IsA('DualMK23Pistol') || Other.IsA('Magnum44Pistol') || Other.IsA('Dual44Magnum') || Other.IsA('HUNTING_RIFLE')) {
        return 1.6; // Up to 60% faster reload with Crossbow/Winchester/Handcannon
    }

    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if (Item.name == 'DeaglePickup' || Item.name == 'DualDeaglePickup' ||
        Item.name == 'MK23Pickup' || Item.name == 'DualMK23Pickup' ||
        Item.name == 'Magnum44Pickup' || Item.name == 'Dual44MagnumPickup'
        || Item.name == 'M14EBRPickup' || Item.name == 'M99Pickup' || Item.name == 'Hunting_RiflePickup') {
        return 0.3; // Up to 70% discount on Handcannon/Dual Handcannons/EBR/44 Magnum(s)
    }
    return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'CrossbowPickup' ) {
        return 0.58; // Up to 42% discount on Crossbow Bolts(Added in Balance Round 4 at 30%, increased to 42% in Balance Round 7)
    }

    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Crossbow", GetCostScaling(KFPRI, class'CrossbowPickup'));
}

defaultproperties {
    PerkIndex=2

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_SharpShooter'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_SharpShooter_Gold'
    VeterancyName="Sharpshooter"
    Requirements(0)="Get %x headshot kills with Pistols, Rifle, Crossbow, M14, or M99"

    SRLevelEffects(0)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(1)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(2)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(3)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(4)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(5)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    SRLevelEffects(6)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
    
    CustomLevelInfo="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
}
