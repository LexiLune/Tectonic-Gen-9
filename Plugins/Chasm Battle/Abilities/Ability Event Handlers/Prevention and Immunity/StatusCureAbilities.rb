BattleHandlers::StatusCureAbility.add(:MENTALBLOCK,
  proc { |ability, battler|
      battle = battler.battle

      activate = battler.hasMentalEffect? || battler.dizzy?

      if activate
          battle.pbShowAbilitySplash(battler, ability)
          battler.disableMentalEffects
          battler.pbCureStatus(true, :DIZZY) if battler.dizzy?
          battle.pbHideAbilitySplash(battler)
      end
  }
)

BattleHandlers::StatusCureAbility.add(:MINDLESS,
  proc { |ability, battler|
      battle = battler.battle

      if battler.hasMentalEffect?
          battle.pbShowAbilitySplash(battler, ability)
          battler.disableMentalEffects
          battle.pbHideAbilitySplash(battler)
      end
  }
)

BattleHandlers::StatusCureAbility.add(:PURIFYINGSALT,
  proc { |ability, battler|
      battle = battler.battle

      activate = battler.burned? || battler.frostbitten? || battler.numbed? || battler.waterlogged? || battler.poisoned? || battler.dizzy?

      if activate
          battle.pbShowAbilitySplash(battler, ability)
          battler.pbCureStatus
          healingMessage = _INTL("{1}'s healing salt cured its status condition.", battler.pbThis)
          battler.applyFractionalHealing(1.0 / 8.0, ability: ability, customMessage: healingMessage)
          battle.pbHideAbilitySplash(battler)
      end
  }
)
