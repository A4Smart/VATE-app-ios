![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)

# wayfindr-demo-ios

# struttura app

# GESTIONE PARTE GRAFICA:

AppDelegate: funzione di partenza che comanda tutto, gestisce le funzioni di background
	ho aggiunto le funzioni di Estimote per il monitoring in background
	chiama la funzione “ModeSelectionTabViewController”

ModeSelectionTabViewController: 
	setta la barra del menu in basso
	chiama le varie “ActionTableViewController” per ciascuna modalità (user, developer, manteiner)

UserActionTableViewController:
	viewDIdLoad: setta titolo e bottone back
	ogni bottone schiacciato apre la SearchTableViewController

ExitSearchTableViewController:
	setta nella tabella i vari item (stazioni, uscite o facilities)
	se schiaccia, si chiama RouteCalculationViewController

RouteCalculationViewController:
	all’interno della funzione
	func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon])
	chiama la funzione determineRoute, che calcola il percorso più veloce
	gestisce due pulsanti, che decidono se avere una preview scritta delle istruzioni o saltarle e andare direttamente alle istruzioni
	in fondo, ci sono le due funzioni: yesButtonPressed (che chiama DirectionsPreviewViewController) e skipButtonPressed
	skipButtonPressed chiama ActiveRouteViewController

ActiveRouteViewController:
	in viewDidAppear chiama beginRoute (legge le istruzioni relative al primo nodo della route)
	in beaconInterface legge i valori dei beacon e se il beacon più vicino corrisponde al nodo 		successivo, chiama continueRoute
	continueRoute: legge le istruzioni relative a tutti i successivi beacon

DemoVenueData.json: file in cui inserire le varie destinazioni

DemoGraphData.graphml: file in cui inserire i vari nodi e i vari edge

WayGraph: definizione del grafo e varie funzioni su nodi e archi
	
WAYConstants: ci sono dei parametri da settare che comandano varie opzioni (tipo se si vuole il flash rosso, se si vuole localizzare con rssi oppure con accuracy, …)

# GESTIONE ALGORITMO NAVIGAZIONE:

DemoBeaconInterface: funzione di gestione bluetooth e lettura beacon

WayGraphNode:

WayGraphEdge:

WayInstructionSet:

WayGraph:
