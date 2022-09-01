import vlc

radios = [
  {
    id: 0,
    'name': 'FIP',
    'url': 'https://icecast.radiofrance.fr/fip-hifi.aac'
  },
  {
    id: 1,
    'name': 'RVL',
    'url': 'https://cast235.indax.cl/8026/stream'
  }
]

# define VLC instance
instance = vlc.Instance()
# define VLC player
player = instance.media_player_new()

def defineRadio(url):
  # define VLC media
  media = instance.media_new(url)
  # set player media
  player.set_media(media)

menuOptions = {
  0: 'Quit',
  1: 'Previous Radio',
  2: 'Play',
  3: 'Pause',
  4: 'Next Radio',
  5: 'Info on Radio'
}

def showMenu():
  print('\n --- MENU --- ')
  for key in menuOptions:
    print(key, ' - ', menuOptions[key])
  print(' --- \n')

# function to change the current radio
def changeRadio(currentRadio, direction):
  player.pause()
  numberOfRadios = len(radios)

  idPrevRadio = currentRadio-1 if currentRadio-1 >= 0 else numberOfRadios-1
  idNextRadio = currentRadio+1 if currentRadio+1 < numberOfRadios else 0

  if direction == 'previous':
    currentRadio = idPrevRadio

  if direction == 'next':
    currentRadio = idNextRadio
    
  defineRadio(radios[currentRadio]['url'])
  player.play()
  print('Changing radio to ' + getRadioName(currentRadio))
  return currentRadio

def getRadioName(currentRadio): 
  radio = radios[currentRadio]
  return radio['name']

if __name__ == '__main__':
    currentRadio = 0
    # configure initial radio
    defineRadio(radios[0]['url'])
    player.play()

    while (True):
      showMenu()
      userChoice = ''

      try:
        userChoice = int(input('Enter your choice (number): \n'))
      except:
        print('Wrong input - a number between 1 and ' + len(menuOptions) + ' is expected')

      if userChoice == 0:
        exit()

      if userChoice == 1:
        currentRadio = changeRadio(currentRadio, 'previous')
      
      if userChoice == 2:
        player.play()

      if userChoice == 3:
        player.pause()

      if userChoice == 4:
        currentRadio = changeRadio(currentRadio, 'next')

      if userChoice == 5:
        print(getRadioName(currentRadio))
