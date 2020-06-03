function(input, output) {
    history_df = eventReactive(input$do_plot, {
        filtered_history = streaming_history[end_time > input$times[1] & end_time < input$times[2], ]
        if (!input$include_skipped) {
            filtered_history = filtered_history[!(skipped), ]
        }
        filtered_history
    })

    output$hours_plot = renderPlot({
        by_hour = history_df()[, .(total_listening_hours = sum(s_played, na.rm = TRUE) / 60), by = "time_hour"]
        by_hour = by_hour[, .(pm_am = ifelse(time_hour < 12 | time_hour == 0, "am", "pm"),
                              hour_12 = time_hour %% 12,
                              time_hour,
                              total_listening_hours)]
        # ggplot(by_hour, aes(x = hour_12, y = total_listening_hours, fill = pm_am)) +
            # geom_bar(stat = "identity") +
            # coord_polar() +
            # facet_wrap(~pm_am) +
            # theme_bw()
        ggplot(by_hour, aes(x = time_hour, y = total_listening_hours)) +
            geom_bar(stat = "identity") +
            theme_bw()
    })

    output$days_plot = renderPlot({
        by_day = history_df()[, .(total_listening_hours = sum(s_played, na.rm = TRUE) / 60), by = "weekday"]
        ggplot(by_day, aes(x =  weekday, y = total_listening_hours)) +
            geom_bar(stat = "identity") +
            theme_bw()
    })
}
