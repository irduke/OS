#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "list_t.h"

void list_init( list_t *l, int (*compare)(const void *key, const void *with), void (*datum_delete)(void *datum) ) {
    l->compare = compare;
    l->datum_delete = datum_delete;
    list_item_t * head = malloc(sizeof(list_item_t));
    list_item_t * tail = malloc(sizeof(list_item_t));


    head->datum = NULL;
    head->next = tail;
    head->pred = NULL;

    tail->datum = NULL;
    tail->next = NULL;
    tail->pred = head;

    l->head = head;
    l->tail = tail;
}

void list_visit_items( list_t *l, void (*visitor)(void *v) ) {
    list_item_t * v = l->head;
    
    while (v != l->tail->pred) {
        v = v->next;
        visitor(v);
    }
}

void list_insert_tail(list_t *l, void *v) {
    //init new node
    list_item_t * new_node = malloc(sizeof(list_item_t));
    new_node->datum = (char *)v;
    new_node->next = l->tail;
    new_node->pred = l->tail->pred;
    //update connections
    l->tail->pred->next = new_node;
    l->tail->pred = new_node;
}

void list_remove_head(list_t *l) {
    list_item_t * del_node = l->head->next;
    if (del_node != l->tail) {
        l->head->next = del_node->next;
        del_node->next->pred = l->head;
        free(del_node->datum);
        free(del_node);
    }
}

int is_empty(list_t * l) {
    if (l->head->next == l->tail) {
        return 1;
    }
    else {
        return 0;
    }
}