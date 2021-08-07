from telegram.ext import Updater, CommandHandler, Filters, MessageHandler
from cl.ExprvEval import *
import os

def start(update, context):
    context.bot.send_message(chat_id=update.effective_chat.id, text="I'm a bot, please talk to me!")

def botPoligon(update, context):
    comanda = update.message.text
    result = str2parse(tree, comanda)
    comanda = comanda.split()
    if ":=" in comanda:
        context.bot.send_message(chat_id=update.message.chat_id, text='Assignada la variable : ' + comanda[0])
    if result != None:
        if os.path.exists(result):
            context.bot.send_photo(chat_id=update.message.chat_id, photo=open(result, 'rb'))
        else:
            context.bot.send_message(chat_id=update.message.chat_id, text=result)

# declara una constant amb el access token que llegeix de token.txt
TOKEN = open('token.txt').read().strip()

# crea objectes per treballar amb Telegram
updater = Updater(token=TOKEN, use_context=True)
dispatcher = updater.dispatcher
tree = ExprEval()

# indica que quan el bot rebi la comanda /start s'executi la funció start
dispatcher.add_handler(CommandHandler('start', start))
updater.dispatcher.add_handler(MessageHandler(Filters.text & (~Filters.command), botPoligon))
# engega el bot
updater.start_polling()
