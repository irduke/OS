typedef struct list_item {
    struct list_item *pred, *next;
    void *datum;
} list_item_t;
