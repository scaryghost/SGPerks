class SGSupportSpec extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum ) {
    if( ReqNum==0 ) {
        FinalInt= CurLevel * 50000;
        return Min(StatOther.RWeldingPointsStat,FinalInt);
    }
    FinalInt= CurLevel * 500000;
    return Min(StatOther.RShotgunDamageStat,FinalInt);
}

static function int AddCarryMaxWeight(KFPlayerReplicationInfo KFPRI) {
    return 9; // 9 more carry slots
}

static function float GetWeldSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    return 2.5; // 150% increase in speed
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType) {
    if ( AmmoType == class'FragAmmo' ) {
        // Up to 6 extra Grenades
        return 2.2;
    }
    else if ( AmmoType == class'ShotgunAmmo' || AmmoType == class'DBShotgunAmmo' || AmmoType == class'AA12Ammo'
        || AmmoType == class'BenelliAmmo' || AmmoType == class'KSGAmmo' || AmmoType == class'NailGunAmmo'
        || AmmoType == class'GoldenBenelliAmmo') {
            return 1.30; // Level 6 - 30% increase in shotgun ammo carried
    }

    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType) {
    if ( DmgType == class'DamTypeShotgun' || DmgType == class'DamTypeDBShotgun' || DmgType == class'DamTypeAA12Shotgun'
        || DmgType == class'DamTypeBenelli' || DmgType == class'DamTypeKSGShotgun' || DmgType == class'DamTypeNailgun' ) {
        return InDamage * 1.6; // Up to 60% more damage with Shotguns
    }
    else if ( DmgType == class'DamTypeFrag' && KFPRI.ClientVeteranSkillLevel > 0 ) {
        return float(InDamage) * 1.5; // Up to 50% more damage with Nades
    }

    return InDamage;
}

// Reduce Penetration damage with Shotgun slower
static function float GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo KFPRI, float DefaultPenDamageReduction) {
    local float PenDamageInverse;

    PenDamageInverse = 1.0 - FMax(0,DefaultPenDamageReduction);

    return DefaultPenDamageReduction + ((PenDamageInverse / 5.5555) * 5);
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if ( Item == class'ShotgunPickup' || Item == class'BoomstickPickup' || Item == class'AA12Pickup'
        || Item == class'BenelliPickup' || Item == class'KSGPickup' || Item == class'NailGunPickup'
        || Item == class'GoldenBenelliPickup') {
        return 0.3; // Up to 70% discount on Shotguns
    }

    return 1.0;
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.BoomStick", GetCostScaling(KFPRI, class'BoomStickPickup'));
}

defaultproperties {
    PerkIndex=1

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Support'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Support_Gold'
    VeterancyName="Support Specialist"
    Requirements(0)="Weld %x door hitpoints"
    Requirements(1)="Deal %x damage with shotguns"
    NumRequirements=2

     SRLevelEffects(1)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
     SRLevelEffects(2)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
     SRLevelEffects(3)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
     SRLevelEffects(4)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
     SRLevelEffects(5)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
     SRLevelEffects(6)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"

     CustomLevelInfo="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
}
