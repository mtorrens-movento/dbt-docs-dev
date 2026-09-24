

with base as (
    select
        *
    from [wh_silver].[stg_qbi].[ventas_almacen]
    where upper(ltrim(rtrim(ref_ind_salida_taller))) = 'S'
),

final as (
    select
        
    
    -- Obtener referencia a 7 digitos o limpiar migradas de otros sistemas (con guión)
    -- El identificador NO es numerico: 116.664 referencias del ultimo snapshot
    -- empiezan por letras (GG5257301...), de ordenes migradas. Castearlo a int las
    -- anula, y como la deduplicacion reparte por esta columna, colapsan entre si:
    -- se perdian 116.208 lineas de OR sin que saltara ningun error. El id_cargo si
    -- es numerico (cero no convertibles en 2.094.570) y ese cast se mantiene.
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            THEN LEFT(id_orden_venta, CHARINDEX('-', id_orden_venta) - 1)
        WHEN LEN(id_orden_venta) > 0
            THEN LEFT(id_orden_venta, LEN(id_orden_venta) - 1)
        ELSE id_orden_venta
    END
 as id_orden_reparacion,
    
    CASE
        WHEN id_orden_venta IS NULL THEN NULL
        WHEN CHARINDEX('-', id_orden_venta) > 0
            -- Obtener valores ala derecha del guion
            THEN try_cast(SUBSTRING(id_orden_venta, CHARINDEX('-', id_orden_venta) + 1, LEN(id_orden_venta)) as int)
        -- Obtener último carácter de referencia original
        ELSE try_cast(RIGHT(id_orden_venta, 1) as int)
    END
 as id_cargo
,
        b.*
    from base b
)

-- aud_tst_ultima_actualizacion ya llega de stg_qbi__ventas_almacen, que la calcula
-- con el mismo macro y sobre las mismas dos columnas. Como aqui se arrastra con
-- select *, volver a anadirla dejaba la vista con la columna repetida y el modelo
-- no se podia crear.
select
    f.*
from final f