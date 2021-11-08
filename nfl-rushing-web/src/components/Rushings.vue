<template>
  <div class="rushings">
    <div class="flex flex-col sm:m-6 lg:m-8">
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div class="shadow overflow-hidden border-b border-gray-200 bg-gray-200">
            <div class="mx-6 my-3 flex justify-between">
              <div>
                <label for="inputQuery">Filter</label>
                <input v-model="inputQuery"
                       id="inputQuery"
                       type="text"
                       placeholder="Player name"
                       class="p-1 ml-1"
                />
              </div>
              <div>
                <a :href="downloadLink" class="underline">Download CSV</a>
              </div>
            </div>
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
              <tr>
                <th v-for="column in columns"
                    :key="column.name"
                    :title="column.title"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">
                  <div v-if="column.sortable">
                    <router-link :to="sortLink(column.name)" :class="[sortColumn === column.name ? 'font-bold' : '']">
                      {{ column.heading }}

                      <span>
                        <span :class="[sortColumn === column.name && sortOrder === 'asc' ? 'text-black' : 'text-gray-500']">
                          &uarr;
                        </span>
                        <span :class="[sortColumn === column.name && sortOrder === 'desc' ? 'text-black' : 'text-gray-500']">
                          &darr;
                        </span>
                      </span>
                    </router-link>
                  </div>
                  <span v-else>
                      {{ column.heading }}
                  </span>
                </th>
              </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="row in items" :key="row.id">
                  <td v-for="column in columns"
                      :key="column.name + row.id"
                      class="px-6 py-3 text-left text-xs">

                    <div v-if="loading" :class="[column.name === 'player_name' ? 'w-24' : 'w-10','animate-pulse','bg-gray-100', 'h-4']"></div>
                    <span v-else>
                      {{ row[column.name] }}
                    </span>
                  </td>
                </tr>
              </tbody>
              <tfoot class="bg-gray-50">
                <tr>
                  <th :colspan="columns.length" class="font-normal text-gray-500">
                    <div class="flex justify-center">
                      <div class="px-3">
                        <router-link :class="[page > 1 ? '' : 'opacity-0']" :to="{ query: {...$route.query, page: page - 1}}">
                          &larr; Previous
                        </router-link>
                      </div>
                      <div class="px-3">
                        {{ page }} / {{ totalPages }}
                      </div>
                      <div class="px-3">
                        <router-link :class="[page < totalPages ? '' : 'opacity-0']" :to="{ query: {...$route.query, page: page + 1}}">
                          Next &rarr;
                        </router-link>
                      </div>
                    </div>
                  </th>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { isEqual, debounce, omit } from 'lodash-es'

export default {
  name: 'Rushings',
  data() {
    return {
      items: [],
      totalCount: 0,
      totalPages: 0,
      loading: false,
      inputQuery: '',
    }
  },
  computed: {
    rushingsApiURL() {
      return 'http://localhost:3000/rushings'
    },
    page() {
      return parseInt(this.$route.query.page) || 1
    },
    sortColumn() {
      return this.$route.query.sort_field
    },
    sortOrder() {
      return this.$route.query.sort_order
    },
    filterQuery() {
      return this.$route.query.query
    },
    downloadLink() {
      // in a real-world app, the backend would ship the file to a storage like AWS S3 and provide a download link
      // streaming directly from the backend for now
      const queryParams = new URLSearchParams(omit({...this.$route.query}, ['page']))

      return `http://localhost:3000/rushings/export?${queryParams.toString()}`
    },
    columns() {
      return [
        {name: "player_name", heading: "Player", title: "Player's name"},
        {name: "team_abbr", heading: "Team", title: "Player's team abbreviation"},
        {name: "pos", heading: "Pos", title: "Player's postion"},
        {name: "attempts", heading: "Att/G", title: "Rushing Attempts Per Game Average"},
        {name: "attempts_per_game", heading: "Att", title: "Rushing Attempts"},
        {name: "yds", heading: "Yds", title: "Total Rushing Yards", sortable: true},
        {name: "avg_yds", heading: "Avg", title: "Rushing Average Yards Per Attempt"},
        {name: "yds_per_game", heading: "Yds/G", title: "Rushing Yards Per Game"},
        {
          name: "total_touchdowns",
          heading: "TD",
          title: "Total Rushing Touchdowns",
          sortable: true
        },
        {
          name: "longest",
          heading: "Lng",
          title: "Longest Rush -- a T represents a touchdown occurred",
          sortable: true
        },
        {name: "first_downs", heading: "1st", title: "Rushing First Downs"},
        {name: "first_downs_percentage", heading: "1st%", title: "Rushing First Down Percentage"},
        {name: "twenty_plus", heading: "20+", title: "Rushing 20+ Yards Each"},
        {name: "forty_plus", heading: "40+", title: "Rushing 40+ Yards Each"},
        {name: "fumbles", heading: "FUM", title: "Rushing Fumbles"},
      ]
    },
  },
  created() {
    this.inputQuery = this.filterQuery
    this.fetchDataByRoute(this.$route)
  },
  beforeRouteUpdate(to, _from, next) {
    this.fetchDataByRoute(to).finally(next)
  },
  watch: {
    inputQuery: function(newQuery) {
      this.applyFilter(newQuery)
    }
  },
  methods: {
    fetchDataByRoute(route) {
      this.lastApiQuery = route.query
      this.loading = true
      return this.$http
          .get(this.rushingsApiURL, { params: route.query })
          .then((response) => {
            if (isEqual(this.lastApiQuery, response.config.params)) {
              this.handleDataResponse(response.data)
            }
          })
          .finally(() => this.loading = false)
    },
    handleDataResponse(data) {
      this.items = data.items
      this.totalCount = data.total_count
      this.totalPages = data.total_pages
    },
    sortLink(field) {
      let newOrder = "desc"
      if (field === this.sortColumn) {
        newOrder = this.sortOrder === "desc" ? "asc" : "desc"
      }

      return { query: { query: this.filterQuery, sort_field: field, sort_order: newOrder } }
    },
    applyFilter(query) {
      debounce(
        () => {
         this.$router.push({ query: {...query && { query: query} }})
        },
        200)()
    }
  }
}
</script>
