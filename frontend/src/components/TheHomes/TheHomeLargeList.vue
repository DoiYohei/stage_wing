<template>
  <v-col>
    <v-card flat>
      <v-list color="#121212">
        <v-list-item-group>
          <v-list-item
            v-for="(item, index) in cardItems"
            :key="index"
            :to="item.path"
          >
            <v-list-item-content>
              <v-card-title :class="textStyle">
                {{ item.text }}
              </v-card-title>
            </v-list-item-content>
          </v-list-item>
          <template v-if="token">
            <v-list-item>
              <v-list-item-content>
                <v-card-title @click="drawer = !drawer" :class="textStyle">
                  MY MENU
                </v-card-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-content>
                <v-card-title @click.stop="openDialog" :class="textStyle">
                  LOG OUT
                </v-card-title>
              </v-list-item-content>
            </v-list-item>
          </template>
        </v-list-item-group>
      </v-list>
    </v-card>
  </v-col>
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
