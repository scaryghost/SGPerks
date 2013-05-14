class SGBerserker extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum) {
    FinalInt= 500000 * CurLevel;
    return Min(StatOther.RMeleeDamageStat,FinalInt);
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType) {
    if(class<KFWeaponDamageType>(DmgType) != none && class<KFWeaponDamageType>(DmgType).default.bIsMeleeDamage) {
        return InDamage * 2;
    }
    return InDamage;
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other) {
    if ( KFMeleeGun(Other) != none  || Crossbuzzsaw(Other) != none) {
        return 1.25;
    }
    return 1.0;
}

static function float GetMeleeMovementSpeedModifier(KFPlayerReplicationInfo KFPRI) {
    return 0.30;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, KFMonster DamageTaker, int InDamage, class<DamageType> DmgType) {
    if (DmgType == class'DamTypeVomit') {
        return float(InDamage) * 0.20; // 80% reduced Bloat Bile damage
    }
    return float(InDamage) * 0.60; // 40% reduced Damage(was 50% in Balance Round 1)
}

static function bool CanMeleeStun() {
    return true;
}

static function bool CanBeGrabbed(KFPlayerReplicationInfo KFPRI, KFMonster Other) {
    return !Other.IsA('ZombieClot');
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
    return 4;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) {
    if (Item == class'ChainsawPickup' || Item == class'KatanaPickup' || Item == class'ClaymoreSwordPickup'
        || Item == class'CrossbuzzsawPickup' || Item == class'ScythePickup' || Item == class'GoldenKatanaPickup'
        || Item == class'MachetePickup' || Item == class'AxePickup' || Item == class'DwarfAxePickup' ) {
        return 0.3; // Up to 70% discount on Melee Weapons
    }

    return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P) {
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Axe", GetCostScaling(KFPRI, class'AxePickup'));
    if ( KFPRI.Level.Game.GameDifficulty < 5.0 && KFPRI.ClientVeteranSkillLevel == 6 )
        P.ShieldStrength = 100;
}

defaultproperties {
    PerkIndex=4

    OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Berserker'
    OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Berserker_Gold'
    VeterancyName="Berserker"
    Requirements(0)="Deal %x damage with melee weapons"

    SRLevelEffects(0)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(1)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(2)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(3)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(4)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(5)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    SRLevelEffects(6)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
    CustomLevelInfo="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on melee weapons|Spawn with an Axe and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}
