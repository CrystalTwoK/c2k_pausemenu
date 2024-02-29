const closeKeys = ['Escape', 'Backspace'];
var audio = new Audio('https://dl.sndup.net/xv3y/button_sfx.mp3')
var audioOver = new Audio('https://dl.sndup.net/v8zn/mouseover_sfx.mp3')
audio.volume = 0.8
let activeListeners = [];
var bottoni = document.querySelectorAll('.menu-button');

$(() => {
	window.addEventListener("message", (event) => {
		const action = event.data.action;
		const data = event.data.data;
		if (action === "show") {
			openHomePage(data);
		}
	});
});

document.onkeydown = function(evt) {
    evt = evt || window.event;
    if (evt.keyCode == 27) {
		hideElements(['body', '#wrap', '#confermaContainer']);
		execute('client_event', 'riprendi')
    }
};


//  DICHIARAZIONE FUNZIONI

const hideElements = (elements) => {
	elements.forEach((key, _) => {
		$(key).fadeOut()
	})
}

const registerActionButton = (element, action) => {
	if (!activeListeners.includes(element)) {
		activeListeners.push(element)
		$(element).on('click', function(event) {
			action($(this), event)
		})
	}
}

const removeActiveListeners = () => {
	activeListeners.forEach((element, index) => {
		$(element).off('click')
	})
	activeListeners = [];
}

const execute = (actionType, action) => {
	$.post(`https://c2k_pausemenu/execute`, JSON.stringify({
		actionType,
		action
	}))
	removeActiveListeners()
}

const openvMenu = () => {
	$.post(`https://c2k_pausemenu/openvmenu`)
	hideElements(['body', '#wrap'])
	removeActiveListeners()
	$.post(`https://c2k_pausemenu/closeNUI`, JSON.stringify({}));
}

const PlaySound = (soundobj) => {
    let sound=document.getElementById(soundobj);
    sound.play();
}

const StopSound = (soundobj) => {
	let sound = document.getElementById(soundobj);
	sound.pause();
    sound.currentTime = 0;
}

const openHomePage = (data) => {
	
	$("body").fadeIn();
	$("#wrap").fadeIn();


	registerActionButton('#riprendi', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'riprendi');
	})

	registerActionButton('#report', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'report');
	})

	registerActionButton('#mappa', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'apriMappa');
	})

	registerActionButton('#impostazioni', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'apriImpostazioni');
	}) 

	registerActionButton('#cambiapg', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'cambiapg');
	})

	registerActionButton('#disconnessione', (element) => {
		$('#confermaContainer').fadeIn();
	})

	registerActionButton('#disconnesioneSi', (e) =>{
		hideElements(['body', '#wrap', '#confermaContainer']);
		execute('server_event', 'quitPlayer');
	})

	registerActionButton('#disconnesioneNo', (e) =>{
		hideElements(['#confermaContainer']);
	})

	registerActionButton('.menu-button', (e)=>{
		PlaySound("mousesfx");
	})

};

bottoni.forEach((e,i) =>{
	e.addEventListener('mouseover', () =>{
		PlaySound('mouseoversfx');
	})

	e.addEventListener('mouseout', () =>{
		StopSound('mouseoversfx');
	})
})

