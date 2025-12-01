#!/bin/bash

# Ci spostiamo nella cartella dello script
cd "$(dirname "$0")"

echo "🚀 INIZIO SETUP AUTOMATICO REPO..."
echo "---------------------------------"

# 1. CREAZIONE STRUTTURA CARTELLE
echo "📂 Creazione cartelle..."
mkdir -p notebooks
mkdir -p web-app
mkdir -p assets

# 2. SPOSTAMENTO FILE (Cerca i file e li sposta se esistono)
echo "📦 Spostamento file..."

# Sposta i notebook (.ipynb)
if ls *.ipynb 1> /dev/null 2>&1; then
    mv *.ipynb notebooks/
    echo "✅ Notebook spostati."
else
    echo "⚠️  Nessun file .ipynb trovato (forse l'hai già spostato?)"
fi

# Sposta index.html
if [ -f "index.html" ]; then
    mv index.html web-app/
    echo "✅ index.html spostato."
fi

# Sposta data.js
if [ -f "data.js" ]; then
    mv data.js web-app/
    echo "✅ data.js spostato."
fi

# 3. CREAZIONE FILE DI DOCUMENTAZIONE
echo "📝 Creazione README e Requirements..."

# Crea requirements.txt
cat <<EOF > requirements.txt
tensorflow>=2.10.0
numpy
pandas
matplotlib
scikit-learn
umap-learn
colorcet
datashader
pillow
EOF

# Crea README.md (Versione base, poi puoi modificarlo)
cat <<EOF > README.md
# Neural Manifold Projection

Interactive visualization tool for exploring the latent space of Fashion-MNIST using Convolutional Autoencoders and UMAP.

## Structure
* \`notebooks/\`: Python code for training and analysis.
* \`web-app/\`: Interactive JS viewer (open index.html).
* \`assets/\`: Demo images and GIFs.

## Usage
1. Run the notebook to generate \`data.js\`.
2. Open \`web-app/index.html\` to explore.
EOF

# 4. GENERAZIONE GIF (Se c'è video.mp4)
if [ -f "video.mp4" ]; then
    echo "🎬 Trovato video.mp4! Converto in GIF..."
    
    # Controlla se ffmpeg esiste
    if ! command -v ffmpeg &> /dev/null; then
        echo "❌ ERRORE: ffmpeg non è installato! Impossibile creare la GIF."
        echo "   Installa ffmpeg o usa un convertitore online."
    else
        # Genera palette
        ffmpeg -v warning -i video.mp4 -vf "fps=15,scale=800:-1:flags=lanczos,palettegen" -y palette.png
        # Genera GIF in assets
        ffmpeg -v warning -i video.mp4 -i palette.png -lavfi "fps=15,scale=800:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y assets/demo_interaction.gif
        rm palette.png
        echo "✅ GIF creata in assets/demo_interaction.gif"
    fi
else
    echo "⚠️  Nessun file 'video.mp4' trovato. Salto la creazione GIF."
fi

echo "---------------------------------"
echo "🎉 TUTTO FATTO!"
echo "Ora puoi trascinare questa cartella su GitHub."
echo ""
read -p "Premi INVIO per chiudere..."