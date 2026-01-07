# Configuración de AWX con NetBox - PLUGIN OFICIAL FUNCIONANDO

## ✅ SOLUCIÓN FINAL - PLUGIN OFICIAL NETBOX v3.22.0

El plugin oficial `netbox.netbox.nb_inventory` funciona correctamente con la configuración adecuada.

## Archivos del proyecto:

### 📁 Archivos esenciales para AWX:
- `requirements.yml` - Dependencias de Ansible
- `netbox_inventory.yml` - Configuración del inventario dinámico
- `ansible.cfg` - Configuración de Ansible optimizada
- `playbook.yml` - Playbook principal
- `test_connectivity.yml` - Playbook de prueba/demo

## Configuración clave que soluciona el problema:

### 1. ansible.cfg
```ini
[inventory]
enable_plugins = netbox.netbox.nb_inventory
cache = True
cache_plugin = memory
cache_timeout = 3600
```

### 2. netbox_inventory.yml
```yaml
plugin: netbox.netbox.nb_inventory
api_endpoint: http://netbox.localhost  # SIN /api
timeout: 60
compose:
  ansible_host: primary_ip4 | default(ansible_host)  # Campo correcto
```

## Pasos para configurar en AWX:

### 1. Obtener token de NetBox
- Accede a NetBox en http://netbox.localhost
- Ve a: Admin > API Tokens > Add
- Crea un token con permisos de lectura

### 2. Configurar inventario dinámico en AWX
1. Resources > Inventories > Add > Add Inventory
2. Nombre: "NetBox Dynamic Inventory"

### 3. Agregar fuente de inventario
1. Dentro del inventario: "Sources" > Add
2. Nombre: "NetBox Source"
3. Tipo: "Sourced from a Project"
4. Proyecto: Tu proyecto Git
5. **Archivo de inventario**: `netbox_inventory.yml`
6. **Variables de entorno**:
   ```yaml
   NETBOX_TOKEN: "tu_token_de_netbox"
   ```
7. Habilita "Update on Project Update"
8. Sincroniza

### 4. Crear Job Template
1. Resources > Templates > Add > Add Job Template
2. Inventario: "NetBox Dynamic Inventory"
3. Proyecto: Tu proyecto Git
4. Playbook: `playbook.yml` o `test_connectivity.yml`

## Resultado esperado:
- ✅ Dispositivos detectados automáticamente desde NetBox
- ✅ IPs primarias configuradas como ansible_host
- ✅ Agrupación automática por roles (device_roles_router)
- ✅ Metadatos completos: sitio, tipo, rol, estado
- ✅ Compatible con variables de entorno para seguridad

## Variables disponibles en playbooks:
- `inventory_hostname` - Nombre del dispositivo
- `primary_ip4` - IP primaria del dispositivo
- `sites[0]` - Sitio del dispositivo
- `device_types[0]` - Tipo de dispositivo
- `device_roles[0]` - Rol del dispositivo
- `status.value` - Estado del dispositivo
- `group_names` - Grupos asignados automáticamente

## Troubleshooting:
- **Error HTML**: Verificar que api_endpoint NO tenga /api al final
- **Timeout**: Aumentar timeout a 60 segundos
- **Sin dispositivos**: Verificar token y permisos en NetBox
- **Variables undefined**: Usar las variables correctas del plugin oficial