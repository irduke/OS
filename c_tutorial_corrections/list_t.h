#include <stdlib.h>
#include "list_item_t.h"


typedef struct list {
    list_item_t *head, *tail;
    unsigned length;
    int (*compare)(const void *key, const void *with);
    void (*datum_delete)(void *);
} list_t;

void list_init( 
    list_t *l, 
    int (*compare)(const void *key, const void *with), 
    void (*datum_delete)(void *datum)
);

void list_visit_items(
    list_t *l, 
    void (*visitor)(void *v)
);

void list_insert_tail(list_t *l, void *v);

void list_remove_head(list_t *l);

int is_empty(list_t * l);