<template>
  <v-list>
    <v-list-item-group>
      <v-row>
        <v-col
          cols="6"
          v-for="(item, index) in cardItems"
          :key="index"
          class="pa-0"
        >
          <v-card outlined tile>
            <v-list-item :to="item.path">
              <v-list-item-content>
                <v-card-actions :class="textStyle">
                  {{ item.text }}
                </v-card-actions>
              </v-list-item-content>
            </v-list-item>
          </v-card>
        </v-col>
        <template v-if="token">
          <v-col cols="6" class="pa-0">
            <v-card outlined tile>
              <v-list-item>
                <v-list-item-content>
                  <v-card-actions @click="drawer = !drawer" :class="textStyle">
                    MY MENU
                  </v-card-actions>
                </v-list-item-content>
              </v-list-item>
            </v-card>
          </v-col>
          <v-col cols="6" class="pa-0">
            <v-card outlined tile>
              <v-list-item>
                <v-list-item-content>
                  <v-card-actions
                    @click.stop="openDialog"
                    :class="`${textStyle} mb-0`"
                  >
                    LOG OUT
                  </v-card-actions>
                </v-list-item-content>
              </v-list-item>
            </v-card>
          </v-col>
        </template>
      </v-row>
    </v-list-item-group>
  </v-list>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
    cardItems: {
      type: Array,
      require: true,
    },
    textStyle: {
      type: String,
      require: true,
    },
  },
  computed: {
    ...mapGetters(["token"]),
    drawer: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    openDialog() {
      this.$emit("open-dialog");
    },
  },
};
</script>
