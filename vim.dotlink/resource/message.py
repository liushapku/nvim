import logging
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

import flask
import sys
import datetime
from flask import (
    Flask,
    abort,
    escape,
    flash,
    Flask,
    make_response,
    redirect,
    render_template,
    request,
    session,
    url_for,
    Response,
)

app = Flask(__name__)

@app.route('/vim', methods=['POST'])
def handle_vim():
    msg = request.form.get('msg')
    if msg:
        print('[', datetime.datetime.now(), '] ', msg, sep='')
    elif msg == '':
        print('==========================')
    return ''

try:
    port = sys.argv[1]
except:
    port = 2005

app.run(host='localhost', port=2005)
