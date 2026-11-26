#=============================================================================
# Protean-style abilities
#=============================================================================
BattleHandlers::UserAbilityStartOfMove.add(:PROTEAN,
  proc { |ability, user, _targets, move, battle|
      moveUseTypeChangeAbility(ability, user, move, battle)
  }
)

BattleHandlers::UserAbilityStartOfMove.copy(:PROTEAN, :FREESTYLE)

BattleHandlers::UserAbilityStartOfMove.add(:MUTABLE,
  proc { |ability, user, _targets, move, battle|
      next if user.effectActive?(:Mutated)
      next unless moveUseTypeChangeAbility(ability, user, move, battle)
      user.applyEffect(:Mutated)
  }
)

BattleHandlers::UserAbilityStartOfMove.add(:SHIFTINGFIST,
  proc { |ability, user, _targets, move, battle|
      moveUseTypeChangeAbility(ability, user, move, battle, true) if move.punchingMove?
  }
)

BattleHandlers::UserAbilityStartOfMove.add(:REFRACTIVE,
  proc { |ability, user, _targets, move, battle|
      moveUseTypeChangeAbility(ability, user, move, battle, true) if move.lightMove?
  }
)

BattleHandlers::UserAbilityStartOfMove.add(:MAKEASCENE,
  proc { |ability, user, _targets, move, battle|
      moveType = move.calcType
      next if user.type2 == moveType
      next unless move.recoilMove?
      user.showMyAbilitySplash(ability)
      typeName = GameData::Type.get(moveType).name
      user.type2 = moveType
      case moveType
      when :WATER, :ICE, :POISON, :PSYCHIC, :GHOST, :DRAGON, :DARK
        user.pbChangeForm(1, _INTL("{1} gained the {2} type!", user.pbThis, typeName))
      when  :FIRE, :ELECTRIC, :FIGHTING, :GROUND, :ROCK
        user.pbChangeForm(2, _INTL("{1} gained the {2} type!", user.pbThis, typeName))
      when :GRASS, :BUG
        user.pbChangeForm(3, _INTL("{1} gained the {2} type!", user.pbThis, typeName))
      else 
        user.pbChangeForm(0, _INTL("{1} gained the {2} type!", user.pbThis, typeName))
      end
      battle.scene.pbRefresh
      user.refreshDataBox
      user.hideMyAbilitySplash
  }
)

BattleHandlers::UserAbilityStartOfMove.add(:RAINBOWTRAIL,
  proc { |ability, user, _targets, move, battle|
      type = move.calcType
      if move.calcTypes.include?(:FIRE) && user.effectActive?(:RainbowTrailEntry)
          user.disableEffect(:RainbowTrailEntry)
          user.showMyAbilitySplash(ability)
          battle.pbDisplay(_INTL("{1}'s rainbows shine with an aura of {2}!", user.pbThis, GameData::Type.get(:FIRE).name))
          battle.scene.pbRefresh
          user.hideMyAbilitySplash
      end
      next if user.pbHasType?(type)
      next if move.id == :STRUGGLE
      if user.effectActive?(:RainbowTrail)
          user.effects[:RainbowTrail].push(type)
      else
          user.applyEffect(:RainbowTrail, [type])
      end

      typeName = GameData::Type.get(type).name
      user.showMyAbilitySplash(ability)
      battle.pbDisplay(_INTL("{1}'s rainbows shine with an aura of {2}!", user.pbThis, typeName))
      battle.scene.pbRefresh
      user.hideMyAbilitySplash
  }
)

BattleHandlers::UserAbilityStartOfMove.add(:STAYOFEXECUTION,
  proc { |ability, user, _targets, move, battle|
      next unless move.sliceMove?
      user.showMyAbilitySplash(ability)
      battle.pbDisplay(_INTL("{1} foresees an imminent demise!", user.pbThis))
      user.hideMyAbilitySplash
  }
)

############################################
# Ability Code for cut or unused abilities
############################################

BattleHandlers::UserAbilityStartOfMove.add(:SHAKYCODE,
  proc { |ability, user, _targets, move, battle|
      moveUseTypeChangeAbility(ability, user, move, battle) if battle.eclipsed?
  }
)
