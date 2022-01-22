<template>
  <v-container fluid>
    <v-row>
      <v-col class="d-flex flex-wrap">
        <v-col cols="12" xl="2" lg="3">
          <v-card>
            <v-card-text>
              <v-text-field
                v-model="keywordInput"
                placeholder="Band名を入力してください"
                prepend-icon="mdi-magnify"
                clearable
                hide-details
              />
            </v-card-text>
          </v-card>
        </v-col>
        <v-col>
          <v-card class="d-flex flex-wrap">
            <v-col
              v-for="(band, index) in displayBands"
              :key="index"
              cols="6"
              xl="2"
              md="3"
              sm="4"
            >
              <v-card :to="`/bands/${band.id}`">
                <v-img :src="band.image.url" />
                <v-card-subtitle>
                  {{ band.name }}
                </v-card-subtitle>
              </v-card>
            </v-col>
          </v-card>
          <v-col>
            <PaginationBlocks :mold-display="moldDisplay" />
            <div v-if="!displayBands.length" class="mt-16">
              該当するアーティストがいません
            </div>
          </v-col>
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import PaginationBlocks from "@/components/PaginationBlocks";
export default {
  components: {
    PaginationBlocks,
  },
  data() {
    return {
      allBands: [],
      keywordInput: "",
      displayBands: [],
    };
  },
  async created() {
    const res = await this.$axios.get("/bands");
    this.allBands = res.data.bands;
    this.moldDisplay();
  },
  computed: {
    filteredBands() {
      if (!this.keywordInput) {
        return this.allBands;
      } else {
        const keyword = this.keywordInput.toLowerCase().trim();
        return this.allBands.filter((band) => {
          return band.name.toLowerCase().includes(keyword);
        });
      }
    },
    rowsPerPage() {
      return this.$vuetify.breakpoint.smAndDown ? 10 : 30;
    },
  },
  methods: {
    moldDisplay() {
      this.$page.rowsPerPage = this.rowsPerPage;
      this.$page.displayContents = this.filteredBands;
      this.displayBands = this.$page.displayContents;
    },
  },
  watch: {
    filteredBands() {
      this.$page.current = 1;
      this.moldDisplay();
    },
  },
};
</script>
