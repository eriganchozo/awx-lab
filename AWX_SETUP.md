# Configuración de AWX con NetBox

## Pasos para configurar el inventario dinámico en AWX:

### 1. Obtener token de NetBox
```bash
# Accede a NetBox en http://netbox.localhost
# Ve a: Admin > API Tokens > Add
# Crea un token con permisos de lectura
# Copia el token generado
```

### 2. Configurar inventario dinámico en AWX
1. Ve a AWX en http://awx.localhost
2. Navega a: Resources > Inventories > Add > Add Inventory
3. Nombre: "NetBox Dynamic Inventory"
4. Guarda el inventario

### 3. Agregar fuente de inventario
1. Dentro del inventario creado, ve a "Sources" > Add
2. Nombre: "NetBox Source"
3. Tipo: "Sourced from a Project"
4. Proyecto: Selecciona tu proyecto Git
5. Archivo de inventario: `netbox_inventory.yml`
6. **Variables de entorno** (muy importante):
   ```yaml
   NETBOX_TOKEN: "tu_token_aqui"
   ```
   O alternativamente en "Variables":
   ```yaml
   netbox_token: "tu_token_aqui"
   ```
7. Habilita "Update on Project Update"
8. Habilita "Update on Launch"
9. Guarda y sincroniza

### 4. Verificar sincronización
- La fuente debe sincronizar sin errores
- Debes ver hosts de NetBox en el inventario
- Si hay errores, revisa los logs de la fuente

### 5. Crear Job Template
1. Ve a: Resources > Templates > Add > Add Job Template
2. Nombre: "Test NetBox Playbook"
3. Inventario: "NetBox Dynamic Inventory"
4. Proyecto: Tu proyecto Git
5. Playbook: `playbook.yml` o `test_connectivity.yml` (para pruebas simples)
6. **Variables extra** (opcional):
   ```yaml
   netbox_token: "tu_token_aqui"
   ```
7. Guarda y ejecuta

## Configuración de variables de entorno en AWX

### Opción 1: En la fuente de inventario (Recomendado)
```yaml
# En Environment Variables de la fuente
NETBOX_TOKEN: "tu_token_de_netbox"
```

### Opción 2: En variables del Job Template
```yaml
# En Extra Variables del Job Template
netbox_token: "tu_token_de_netbox"
```

### Opción 3: Usando AWX Credentials (Más seguro)
1. Crea una credencial personalizada:
   - Tipo: "Custom"
   - Campos de entrada:
     ```yaml
     fields:
       - id: netbox_token
         type: string
         secret: true
         label: NetBox API Token
     ```
2. Usa la credencial en el Job Template

## Troubleshooting

### Error: "HTML en lugar de JSON"
- ✅ **Solucionado**: URL corregida a `http://netbox.localhost/api`
- Verifica que el token sea válido y tenga permisos
- Asegúrate de que NetBox esté accesible desde AWX

### Error: "Authentication failed"
- Verifica que el token esté configurado correctamente
- Comprueba que el token no haya expirado
- Revisa los permisos del token en NetBox

### Error: "No hosts found"
- Verifica que tengas dispositivos activos en NetBox
- Revisa el filtro `status: "active"` en el inventario
- Comprueba los logs de sincronización en AWX

### Para pruebas locales (opcional):
```bash
# Exportar token como variable de entorno
export NETBOX_TOKEN="tu_token_aqui"

# Probar inventario localmente
./test_netbox_inventory.sh
```