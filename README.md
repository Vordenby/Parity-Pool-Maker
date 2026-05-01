# PoolMaker-PowerShell
The scfipt for Lab Work No.3 for creating a Storage Spaces pool, optionally builds a parity virtual disk with initialization and creates a partition on it with NTFS format.

# Script

## RUS

Данный скрипт предназначен для лабораторной работы №3 по дисциплине «Операционные системы» в рамках курса «Интеграция прикладных решений и облачных технологий». Его основная задача состоит в том, чтобы упростить создание пула хранения и виртуального диска с отказоустойчивостью типа «четность» в среде Windows Storage Spaces.

Суть работы кода заключается в том, что он автоматически находит диски, которые доступны для объединения в пул, после чего предлагает пользователю выбрать нужные носители через графическое окно выбора. 

### Опционально

После выбора дисков скрипт создаёт пул хранения, затем создаёт виртуальный диск с типом устойчивости Parity, задаёт ему размер, после чего инициализирует диск, создаёт раздел и форматирует его в файловую систему NTFS.

## ENG

This script was created for Laboratory Work No. 3 for the course “Operating Systems” within the program “Integration of Applied Solutions and Cloud Technologies.” Its main purpose is to simplify the creation of a storage pool and a parity-based virtual disk in the Windows Storage Spaces environment.

The core idea of the code is to automatically detect disks that are available for pooling and then allow the user to select the required drives through a graphical selection window.

### Optional

After the disks are selected, the script creates a storage pool, then creates a parity virtual disk, assigns its size, initializes the disk, creates a partition, and formats it as NTFS.
