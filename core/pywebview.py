#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  pywebview.py
#  
#  Author: thezero <silvethebest@yahoo.it>
#  Start date: 29/08/2013  
#  
#  For distribution compile with:
#  $ pyinstaller ./pywebview.py -F
#

import gtk
import webkit
import sys, warnings

#Dichiarazione della home page
page='http://'
width=600
height=600

#inizio Programma
try:
	page=sys.argv[1]
	try:
		page.index("://")
	except:
		page = "http://"+page
    
	width=int(sys.argv[2])
	height=int(sys.argv[3])

except:
	warnings.warn("No argument given. Switch to Default settings", Warning)
	
#crea finestra grafica
win = gtk.Window()
#crea visualizzazione web
webview = webkit.WebView()
#crea finestra con scroll
sw = gtk.ScrolledWindow()

def on_load_finished(self, browser):
	html = browser.get_title()
	if html != None:
		win.set_title(html+" - Fuku WebView")
	else:
		win.set_title("Fuku WebView")

#alcune impostazioni per la kiosk
win.set_size_request(width,height)
win.set_decorated(True)
win.connect("destroy", lambda q: gtk.main_quit())

#carica la pagina nella webview
webview.load_uri(page)
webview.connect('load-finished', on_load_finished)

#aggiunge gli elementi figli nei genitori
win.add(sw)
sw.add(webview)

#disegna tutto
win.show_all()
gtk.main()


