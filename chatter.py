# -*- coding: utf-8 -*-
from chatterbotapi import ChatterBotFactory, ChatterBotType
import sys
"""
    chatterbotapi
    Copyright (C) 2011 pierredavidbelanger@gmail.com
"""

factory = ChatterBotFactory()

bot1 = factory.create(ChatterBotType.CLEVERBOT)
bot1session = bot1.create_session()

bot2 = factory.create(ChatterBotType.PANDORABOTS, 'b0dafd24ee35a477')
bot2session = bot2.create_session()

s = sys.argv[1]
s = bot2session.think(s);
print s
