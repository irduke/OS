#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list_t.h"
#define FALSE 0
#define TRUE 1
#define LINE_MAX_SIZE 42

void visitor_func(void *v);

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("%d argument(s) supplied, 3 expected\n", argc);
        exit(1);
    }
    else if ((strcmp(argv[2], "echo") != 0) && (strcmp(argv[2], "tail") != 0) && (strcmp(argv[2], "tail-remove") != 0))
    {
        printf("Invalid command supplied\n");
        exit(1);
    }

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        perror("Unable to open file specified");
        exit(1);
    }
    else
    {
        fseek(fp, 0L, SEEK_END);
        int size = ftell(fp);
        if (0 == size)
        {
            printf("<EMPTY>\n");
        }
        fseek(fp, 0L, SEEK_SET);
    }

    char line[LINE_MAX_SIZE];
    list_t l;
    list_init(&l, NULL, NULL);
    int print_list = FALSE;
    int rem_list = FALSE;

    while (fgets(line, sizeof(line), fp) != NULL)
    {
        if (strcmp(argv[2], "echo") == 0)
        {
            fputs(line, stdout);
            printf("\n");
        }
        else if (strcmp(argv[2], "tail") == 0)
        {
            char *str = malloc(LINE_MAX_SIZE * sizeof(char));
            strcpy(str, line);
            list_insert_tail(&l, str);
            print_list = TRUE;
        }
        else if (strcmp(argv[2], "tail-remove") == 0)
        {
            char *str = malloc(LINE_MAX_SIZE * sizeof(char));
            strcpy(str, line);
            list_insert_tail(&l, str);
            rem_list = TRUE;
        }
    }
    fclose(fp);

    if (print_list)
    {
        list_visit_items(&l, visitor_func);
        printf("\n");
    }
    else if (rem_list)
    {
        while (!is_empty(&l))
        {
            for (int i = 0; i < 3; i++)
            {
                if (!is_empty(&l))
                {
                    list_remove_head(&l);
                }
                else
                {
                    break;
                }
            }
            list_visit_items(&l, visitor_func);
            printf("\n------------------------\n");
        }
    }
}

void visitor_func(void *v)
{
    list_item_t *nodep = (list_item_t *)v;
    printf("%s", nodep->datum);
}