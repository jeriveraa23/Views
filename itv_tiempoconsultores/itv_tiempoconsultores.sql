-- public.itv_tiempoconsultores source

CREATE OR REPLACE VIEW public.itv_tiempoconsultores
AS SELECT article.id AS nota,
    ticket.id AS ticket_id,
    ticket.tn AS ticket,
    concat(users.first_name, ' ', users.last_name) AS consultor,
    dfv1.value_text::integer AS tiempo,
    article.create_time AS fecha_creacion,
    ticket_type.name AS tipo,
    COALESCE(service.name, 'SIN SERVICIO'::character varying) AS servicio,
    COALESCE(dfv2.value_text, 'SIN MODALIDAD'::character varying) AS impacto,
    ticket.customer_id AS cliente
   FROM article
     LEFT JOIN ticket ON ticket.id = article.ticket_id
     LEFT JOIN service ON ticket.service_id = service.id
     LEFT JOIN users ON users.id = article.create_by
     LEFT JOIN dynamic_field_value dfv1 ON dfv1.object_id = article.id
     LEFT JOIN dynamic_field_value dfv2 ON dfv2.object_id = ticket.id AND dfv2.field_id = 4
     LEFT JOIN ticket_type ON ticket_type.id = ticket.type_id
  WHERE dfv1.field_id = 23 and ticket_type.name in ('PROYECTO','PROCESO','Unclassified')
UNION 
 SELECT article.id AS nota,
    ticket.id AS ticket_id,
    ticket.tn AS ticket,
    concat(users.first_name, ' ', users.last_name) AS consultor,
    dfv1.value_text::integer AS tiempo,
    article.create_time AS fecha_creacion,
    ticket_type.name AS tipo,
    COALESCE(service.name, 'SIN SERVICIO'::character varying) AS servicio,
    COALESCE(dfv2.value_text, 'SIN MODALIDAD'::character varying) AS impacto,
    ticket.customer_id AS cliente
   FROM article
     LEFT JOIN ticket ON ticket.id = article.ticket_id
     LEFT JOIN service ON ticket.service_id = service.id
     LEFT JOIN users ON users.id = article.create_by
     LEFT JOIN dynamic_field_value dfv1 ON dfv1.object_id = article.id
     LEFT JOIN dynamic_field_value dfv2 ON dfv2.object_id = ticket.id AND dfv2.field_id = 4
     LEFT JOIN ticket_type ON ticket_type.id = ticket.type_id
  WHERE dfv1.field_id = 23 and ticket_type.name not in ('PROYECTO','PROCESO','Unclassified')
UNION
 SELECT time_accounting.article_id AS nota,
    ticket.id AS ticket_id,
    ticket.tn AS ticket,
    concat(users.first_name, ' ', users.last_name) AS consultor,
    time_accounting.time_unit::integer AS tiempo,
    time_accounting.create_time AS fecha_creacion,
    ticket_type.name AS tipo,
    COALESCE(service.name, 'SIN SERVICIO'::character varying) AS servicio,
    COALESCE(dfv.value_text, 'SIN MODALIDAD'::character varying) AS impacto,
    ticket.customer_id AS cliente
   FROM time_accounting
     LEFT JOIN ticket ON ticket.id = time_accounting.ticket_id
     LEFT JOIN users ON users.id = time_accounting.create_by
     LEFT JOIN ticket_type ON ticket_type.id = ticket.type_id
     LEFT JOIN service ON ticket.service_id = service.id
     LEFT JOIN dynamic_field_value dfv ON dfv.object_id = ticket.id AND dfv.field_id = 4
  WHERE ticket_type.name::text in ('PROYECTO','PROCESO','Unclassified')
  ORDER BY 2;