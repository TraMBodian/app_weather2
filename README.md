# app_weather

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Membres du groupe:
Fatou Kiné Touré
Tra Mamadou Bodian

## Description de l'application:
        
    
Le code de la page main.dart représente une application mobile de météo qui s'ouvre sur la page d'accueil, contenant un gif, le titre "SEN METEO", un texte d'invitation pour obtenir les données météorologiques d'une ville et un bouton "Voir les prévisions" qui permet de naviguer vers une autre page optimisée les prévisions météorologiques.

Le code commence par importer deux packages nécessaires pour l'application, "progression.dart" et "flutter/material.dart". La fonction "main" initialise l'application en payant une instance de la classe MyApp. La classe MyApp étend StatelessWidget et définit l'interface de l'application, comprenant le titre, le thème et la page d'accueil. La classe MyHomePage étend StatefulWidget et définit la page d'accueil, qui contient un Scaffold, une appBar et un body.

Le corps de la page d'accueil est un Stack contenant un gif, deux positions de texte pour le titre et le texte d'invitation, et un bouton qui, lorsqu'il est pressé, navigue vers une autre page (Progression) où sont affichées les prévisions météorologiques.

## PROGRESSION.DART
La page progression.dart récupère les données météorologiques de cinq villes différentes en utilisant l'API OpenWeatherMap. L'application affiche d'abord un écran de progression avec une barre de progression linéaire pour montrer l'avancement du téléchargement des données. Une fois que les données sont importées, elles sont affichées dans une liste avec les noms de ville, la température, l'humidité et la description du temps. Les données sont téléchargées en arrière-plan en utilisant une combinaison de fonctions asynchrones, de boucles futures et d'un temps précisé(secondes) pour éviter que l'interface utilisateur ne se bloque pendant le téléchargement des données. L'interface utilisateur est également décorée avec un gif d'arrière-plan pour une meilleure expérience utilisateur.