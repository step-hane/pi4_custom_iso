#!/bin/bash -e
# Trouver la partition racine montée
PART_ROOT=$(findmnt / -o SOURCE -n)
# Redimensionner le système de fichiers ext4
resize2fs "$PART_ROOT"
# Supprimer ce hook pour les futurs boots
rm -- "$0"
