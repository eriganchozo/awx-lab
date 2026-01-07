#!/bin/bash

echo "=== Verificando variables de entorno ==="
if [ -z "$NETBOX_TOKEN" ]; then
    echo "⚠️  NETBOX_TOKEN no está configurado"
    echo "   Ejecuta: export NETBOX_TOKEN='tu_token_aqui'"
else
    echo "✅ NETBOX_TOKEN está configurado"
fi

echo -e "\n=== Probando conectividad a NetBox API ==="
if [ -n "$NETBOX_TOKEN" ]; then
    curl -H "Authorization: Token $NETBOX_TOKEN" \
         -H "Accept: application/json" \
         http://netbox.localhost/api/ 2>/dev/null | head -5
else
    curl -v http://netbox.localhost/api/ 2>&1 | head -10
fi

echo -e "\n=== Probando inventario dinámico ==="
if command -v ansible-inventory &> /dev/null; then
    ansible-inventory -i netbox_inventory.yml --list
else
    echo "❌ ansible-inventory no está disponible"
fi

echo -e "\n=== Probando hosts disponibles ==="
if command -v ansible-inventory &> /dev/null; then
    ansible-inventory -i netbox_inventory.yml --graph
else
    echo "❌ ansible-inventory no está disponible"
fi