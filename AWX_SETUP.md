# Configuración de AWX con NetBox - PLUGIN OFICIAL FUNCIONANDO

## ✅ SOLUCIÓN FINAL - PLUGIN OFICIAL NETBOX v3.22.0

El plugin oficial `netbox.netbox.nb_inventory` funciona correctamente con la configuración adecuada.

## Estructura del proyecto:

```
awx-netbox-integration/
├── README.md
├── ansible.cfg                     # Configuración Ansible
├── requirements.yml                # Dependencias (netbox.netbox v3.22.0)
├── inventories/
│   └── netbox_inventory.yml       # Inventario dinámico NetBox
├── playbooks/
│   ├── playbook.yml               # Playbook principal
│   └── test_connectivity.yml      # Playbook de prueba
└── docs/
    └── AWX_SETUP.md               # Documentación completa
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
5. **Archivo de inventario**: `inventories/netbox_inventory.yml`
6. **Variables de entorno** (CRÍTICO para conectividad):
   ```yaml
   NETBOX_TOKEN: "tu_token_de_netbox"
   NETBOX_URL: "http://netbox.netbox.svc.cluster.local"
   ```
7. Habilita "Update on Project Update"
8. Sincroniza

### 4. Crear Job Template
1. Resources > Templates > Add > Add Job Template
2. Inventario: "NetBox Dynamic Inventory"
3. Proyecto: Tu proyecto Git
4. **Playbook**: `playbooks/playbook.yml`

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