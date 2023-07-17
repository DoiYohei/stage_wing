<template>
  <v-dialog
    v-model="dialog"
    max-width="1000"
    overlay-color="white"
    overlay-opacity="0.2"
    persistent
  >
    <v-card color="#121212">
      <v-container>
        <CardPageTitle title="Lineup" />
        <v-row>
          <v-col>
            <v-card-text>
              <v-autocomplete
                v-model="lineup.newLineup"
                :items="registeredBands"
                item-text="name"
                no-data-text="登録されていません"
                label="本サイトに登録されているアーティスト"
                chips
                clearable
                deletable-chips
                multiple
                outlined
                return-object
              />
              <v-combobox
                v-model="lineup.newNoIdLineup"
                label="本サイトに登録されていないアーティスト"
                hint="各アーティストごとにEnterキーを入力してください。"
                chips
                clearable
                deletable-chips
                multiple
                outlined
              />
              <AlertError
                :value="isOverText"
                text="「本サイトに登録されていないBand」の総文字数が多いため登録できません。"
              />
            </v-card-text>
            <v-card-actions>
              <v-spacer />
              <v-btn
                @click="selectSubmit"
                color="grey darken-3"
                :disabled="isOverText"
              >
                {{ textForSubmit }}
              </v-btn>
              <v-btn @click="selectClear" color="grey darken-3">
                {{ textForClear }}
              </v-btn>
              <v-spacer />
            </v-card-actions>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import AlertError from "@/components/Alerts/AlertError";

export default {
  components: {
    CardPageTitle,
    AlertError,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
    dialog: {
      type: Boolean,
      require: true,
    },
    textForSubmit: {
      type: String,
      require: true,
    },
    textForClear: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      registeredBands: [],
    };
  },
  async created() {
    const res = await this.$axios.get("/bands");
    this.registeredBands = res.data.bands;
  },
  computed: {
    lineup: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    isOverText() {
      return this.lineup.newNoIdLineup.join("*/").length > 1000;
    },
  },
  methods: {
    selectSubmit() {
      this.$emit("select-submit");
    },
    selectClear() {
      this.$emit("select-clear");
    },
  },
};
</script>
