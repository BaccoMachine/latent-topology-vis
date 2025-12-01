from moviepy import VideoFileClip
import os

# CONFIGURAZIONE
file_input = "video2.mov"       # Cambia con il nome del tuo file se serve
nome_output = "video1_opt.mp4"  # Nome del file finale
TARGET_MB = 8.5                 # Punto a 8.5 MB per stare sicuro sotto i 9 MB

def comprimi_video():
    if not os.path.exists(file_input):
        print(f"Errore: Non trovo '{file_input}'")
        return

    print(f"Caricamento {file_input}...")
    clip = VideoFileClip(file_input)
    
    # 1. Calcolo del Bitrate necessario
    # Formula: (Dimensione Target in bit) / Durata in secondi
    durata = clip.duration
    target_size_bits = TARGET_MB * 8 * 1024 * 1024
    target_bitrate = int(target_size_bits / durata)
    
    print(f"Durata video: {durata:.2f} secondi")
    print(f"Obiettivo: {TARGET_MB} MB")
    print(f"Bitrate calcolato: {target_bitrate/1000:.0f} kbps")

    # 2. Conversione
    # preset='slow' aiuta a mantenere qualità migliore a parità di dimensione
    print("Inizio compressione (mantengo FPS originali)...")
    
    clip.write_videofile(
        nome_output, 
        codec="libx264", 
        audio_codec="aac", 
        bitrate=f"{target_bitrate}",
        preset="slow",
        logger=None  # Rimuove la barra se ti dava fastidio, o toglilo per vederla
    )
    
    # 3. Verifica finale
    clip.close()
    dimensione_finale = os.path.getsize(nome_output) / (1024 * 1024)
    print("-" * 30)
    print(f"FATTO! File: {nome_output}")
    print(f"Dimensione finale: {dimensione_finale:.2f} MB")

if __name__ == "__main__":
    comprimi_video()