BattleHandlers::AbilityOnEnemySwitchIn.add(:DETERRENT,
    proc { |ability, switcher, bearer, battle|
        battle.pbShowAbilitySplash(bearer, ability)
        if switcher.takesIndirectDamage?(true)
            battle.pbDisplay(_INTL("{1} was attacked on sight!", switcher.pbThis))
            switcher.applyFractionalDamage(1.0 / 8.0)
        end
        battle.pbHideAbilitySplash(bearer)
    }
)

#===============================================================================
# Whenever an opponent switches in while a Pokemon with this ability is active,
# the switcher's Speed is lowered by 3 steps. (Spidops' Web Weaver)
#===============================================================================
BattleHandlers::AbilityOnEnemySwitchIn.add(:WEBWEAVER,
    proc { |ability, switcher, bearer, battle|
        battle.pbShowAbilitySplash(bearer, ability)
        switcher.tryLowerStat(:SPEED, bearer, increment: 3, showFailMsg: true)
        battle.pbHideAbilitySplash(bearer)
    }
)

############################################
# Ability Code for cut or unused abilities
############################################

BattleHandlers::AbilityOnEnemySwitchIn.add(:CLAUSTROPHOBIA,
    proc { |ability, switcher, bearer, battle|
        next unless battle.roomActive?
        battle.pbShowAbilitySplash(bearer, ability)
        if switcher.pbHasType?(:DARK)
            battle.pbDisplay(_INTL("{1} is immune to the pressure of the walls!", switcher.pbThis))
        elsif switcher.takesIndirectDamage?(true)
            battle.pbDisplay(_INTL("The walls close in on {1}!", switcher.pbThis))
            getTypedHazardHPRatio = battle.getTypedHazardHPRatio(:PSYCHIC, switcher, ratio: 1.0/6.0)
            switcher.applyFractionalDamage(getTypedHazardHPRatio)
        end
        battle.pbHideAbilitySplash(bearer)
    }
)