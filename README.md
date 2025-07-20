# Tesla Connector - Flutter App

Una applicazione Flutter per la gestione dell'autenticazione OAuth2 con l'API Tesla.

## Come può esserti utile questo progetto come agente di sviluppo Flutter

Questo progetto è stato strutturato per offrirti il massimo supporto nello sviluppo Flutter con VSCode:

### 🛠️ Configurazione VSCode Ottimizzata

- **Estensioni raccomandate**: Il file `.vscode/extensions.json` include tutte le estensioni essenziali per Flutter
- **Configurazione di debug**: File `.vscode/launch.json` con configurazioni predefinite per debug, profile e release
- **Impostazioni ottimizzate**: File `.vscode/settings.json` con configurazioni per hot reload, formatting automatico e analisi del codice

### 📱 Architettura Flutter Pulita

- **Struttura modulare**: Organizzazione del codice in `screens/`, `services/`, e `models/`
- **Separazione delle responsabilità**: UI separata dalla logica di business
- **Codice riutilizzabile**: Servizi e componenti modulari

### 🔧 Strumenti di Sviluppo

- **Linting avanzato**: File `analysis_options.yaml` con regole per codice di qualità
- **Testing**: Test unitari configurati per i servizi
- **Hot Reload**: Configurazione ottimizzata per sviluppo rapido

### 🚀 Come iniziare

1. **Installa Flutter**: [Guida ufficiale](https://docs.flutter.dev/get-started/install)

2. **Apri in VSCode**: 
   ```bash
   code .
   ```

3. **Installa le dipendenze**:
   ```bash
   flutter pub get
   ```

4. **Avvia l'app**:
   ```bash
   flutter run
   ```

### 🧪 Testing

Esegui i test con:
```bash
flutter test
```

### 📦 Dipendenze Principali

- `http`: Per le chiamate API
- `url_launcher`: Per aprire URL esterni
- `crypto`: Per le funzionalità PKCE
- `shared_preferences`: Per il salvataggio locale

### 🎯 Funzionalità Implementate

- ✅ Generazione URL OAuth2 Tesla
- ✅ Supporto PKCE per sicurezza avanzata
- ✅ Interfaccia utente intuitiva
- ✅ Copia e apertura URL
- ✅ Validazione parametri

### 🔄 Workflow di Sviluppo Suggerito

1. **Sviluppo**: Usa `F5` per avviare in debug mode
2. **Test**: Esegui `flutter test` per i test unitari
3. **Analisi**: Il linter ti guiderà per codice di qualità
4. **Hot Reload**: Salva per vedere i cambiamenti istantaneamente

### 📚 Prossimi Passi

Per espandere l'applicazione, considera:
- Implementazione completa del flusso OAuth2
- Gestione dei token di accesso
- Interfaccia per le API Tesla
- Persistenza sicura dei dati
- Testing di integrazione

Questo setup ti fornisce una base solida per lo sviluppo Flutter professionale!
