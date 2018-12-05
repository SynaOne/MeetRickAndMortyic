# MeetRickAndMortyic

Pour compiler le projet, ne pas oublier d'utiliser la commande "pod install" en se situant dans le dossier "MeetRickAndMortyic".

Ce projet contient peu de pods car ceux-ci sont maintenus par des développeurs externes à Apple. En cas de montée de version de Swift, si le pod n'est plus maintenu, il peut devenir inutilisable. Il faudra donc trouver une solution de contournement qui peut être coûteuse si de nombreux pods ne sont plus maintenus.

La gestion de l'accès aux datas en instantannée (via Reachability) n'a pas été développée car je ne possède pas de device physique, il est donc difficile de tester rapidement cette fonctionnalité. Cependant, en cas d'absence de réseau lors du chargement, l'utilisateur sera informé.

Des fonctionnalités annexes ont été rajoutées comme le tri ou le filtre. Cela permet de naviguer plus facilement dans la liste des personnages.
