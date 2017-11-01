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
    tp = request.form.get('type')
    if msg:
        pre = '\033[31m' if tp == 'error' else ''
        post = '\033[0m' if tp == 'error' else ''
        print(pre, '[', datetime.datetime.now(), '] ', msg, post, sep='')
    elif msg == '':
        print('==========================')
    return ''

try:
    port = sys.argv[1]
except:
    port = 2005

app.run(host='localhost', port=port)
